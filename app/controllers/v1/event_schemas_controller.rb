class V1::EventSchemasController < V1::BaseController
  before_action :set_event_schema, only: [:show, :update, :destroy]

  # GET /event_schemas
  def index
    start_date = Time.parse(params[:start_date]).utc 
    end_date = Time.parse(params[:end_date]).utc

    results = Array.new

    event_schemas = EventSchema.where("church_id = ? AND ( (is_recurring = false AND start_date >= ? AND end_date <= ?) OR (is_recurring = true AND (start_date >= ? OR end_date <= ?)) )", @current_user.church_id, start_date, end_date, start_date, end_date).select("event_schemas.id, title, description, start_date, end_date, color, is_recurring, recurrence, duration").order(updated_at: :desc, start_date: :desc)

    event_schemas.each do |event|
      if event.is_recurring
        results.concat(generate_events_from_rrule(event, start_date, end_date))
      else
        results.push(event)
      end
    end

    render json: results
  end

  # GET /event_schemas/1
  def show
    render json: @event_schema
  end

  # POST /event_schemas
  def create
    @event_schema = EventSchema.new(event_schema_params)
    results = Array.new
    startDate = Time.parse(params[:startDate]).utc 
    endDate = Time.parse(params[:endDate]).utc

    # if end_date is absent, event is assumed to be inifinite
    # we use 5 years from for inifite events

    if @event_schema.end_date.blank?
      @event_schema.end_date = DateTime.now..DateTime::Infinity.new
    end

    if @event_schema.save
      if @event_schema.is_recurring
        results.concat(generate_events_from_rrule(@event_schema, startDate, endDate))
      else
        results.push(@event_schema)
      end
      render json: results, status: :created
    else
      render json: @event_schema.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /event_schemas/1
  def update
    if @event_schema.update(event_schema_params)
      render json: @event_schema
    else
      render json: @event_schema.errors, status: :unprocessable_entity
    end
  end

  # DELETE /event_schemas/1
  def destroy
    @event_schema.destroy
  end

  def update_all_recurrences
    startDate = Time.parse(params[:data][:startDate]).utc 
    endDate = Time.parse(params[:data][:endDate]).utc

    old_event = EventSchema.find(params[:id])
    old_event.end_date = params[:end_date]
    old_event.save

    new_event = old_event.dup
    new_event.start_date = params[:data][:start_date]
    new_event.recurrence = params[:data][:recurrence]
    new_event.end_date = params[:data][:end_date]


    if new_event.save
      render json: {status: true}, status: :created
    else
      render json: new_event.errors, status: :unprocessable_entity
    end
  end

  def upcoming_events
    start_date = Time.now
    end_date = start_date + 1.months
    limit = params[:limit] || 15
    results = Array.new

    event_schemas = EventSchema.where("church_id = ? AND ( (is_recurring = false AND start_date >= ? AND end_date <= ?) OR (is_recurring = true AND (start_date >= ? OR end_date <= ?)) )", @current_user.church_id, start_date, end_date, start_date, end_date).select("event_schemas.id, title, description, start_date, end_date, color, is_recurring, recurrence, duration").order(start_date: :asc, updated_at: :desc).limit(limit)

    event_schemas.each do |event|
      if event.is_recurring
        results.push(generate_event_from_rrule(event, start_date, end_date))
      else
        results.push(event)
      end
    end

    render json: results
  end

  def add_event_to_groups
    group_ids = params[:group_ids]
    event_schema_id = params[:event_schema_id]

    group_ids.each do |group_id|
      EventGroup.create({
        event_schema_id: event_schema_id,
        group_id: group_id
      })
    end

    render json: { status: true }
  end

  def get_events_for_group
    group_id = params[:group_id]
    limit = params[:limit] || 15

    start_date = Time.now
    end_date = start_date + 1.months
    results = Array.new

    event_schemas = EventSchema.joins("INNER JOIN event_groups ON event_groups.event_schema_id = event_schemas.id").where("church_id = ? AND event_groups.group_id = ? AND ( (is_recurring = false AND start_date >= ? AND end_date <= ?) OR (is_recurring = true AND (start_date >= ? OR end_date <= ?)) )", @current_user.church_id, group_id, start_date, end_date, start_date, end_date).select("event_schemas.id, title, description, start_date, end_date, color, is_recurring, recurrence, duration").order(start_date: :asc, updated_at: :desc).limit(limit)

    logger.debug event_schemas.size

    event_schemas.each do |event|
      if event.is_recurring
        results.push(generate_event_from_rrule(event, start_date, end_date))

      else
        results.push(event)
      end
    end

    render json: results

  end

  def get_updates
    events = EventSchema.where(church_id: @current_user.church_id).select(:id, :title, :start_date, :color, :duration).limit(10).order(updated_at: :desc)
    render json: events
  end

  def get_events_density_stats
    interval = params[:interval] || 'month'
    count = params[:count].to_i || 19

    end_date = Time.now
    start_date = count.send(interval).ago
    interval_value = "1 #{interval}"

    label_query = "
    SELECT generate_series(timestamp ?, timestamp ?, interval ?) AS labels ORDER  BY 1;
    "

    series_query = "
    SELECT labels, count(e.start_date) AS events
    FROM  (SELECT generate_series(timestamp ?, timestamp ?, interval ?)) g(labels)
    LEFT   JOIN event_schemas e ON e.start_date >= g.labels
    AND e.start_date <  g.labels + interval ?
    AND e.is_recurring = ?
    GROUP  BY 1
    ORDER  BY 1;
    "

    labels = EventSchema.find_by_sql([label_query, start_date, end_date, interval_value]).pluck(:labels)
    non_recurring_series = EventSchema.find_by_sql([series_query, start_date, end_date, interval_value, interval_value, false]).pluck(:events)

    render json: {labels: labels, series: [non_recurring_series], interval: interval, count: count, start_date: start_date, end_date: end_date}
  end

  private

    def generate_events_from_rrule(event, start_date, end_date)
      results = Array.new
      recurrence = event.recurrence.split('RRULE:')[1]
      rrule = RRule::Rule.new(recurrence, dtstart: event.start_date)

      recurrence_end_date = end_date < event.end_date ? end_date : event.end_date

      rrule.between(start_date, recurrence_end_date).each do |event_date|
        gen_event = event.dup
        gen_event.id = event.id
        gen_event.start_date = event_date
        gen_event.is_exception = false

        # check if event is cancelled or rescheduled
        event_exception = EventException.where("event_schema_id = ? AND exception_date = ?", gen_event.id, gen_event.start_date).first

        if event_exception.present?
          if EventException.statuses[event_exception.status] == EventException.statuses[:cancelled] # cancelled 
            next
          else # resceduled
            gen_event.start_date = event_exception.start_date
            gen_event.end_date = event_exception.end_date
            gen_event.is_exception = true
          end
        end
        
        results.push(gen_event)
      end

      results
    end

    def generate_event_from_rrule(event, start_date, end_date)
      recurrence = event.recurrence.split('RRULE:')[1]
      rrule = RRule::Rule.new(recurrence, dtstart: event.start_date)
      logger.debug "Generating events for More ::: " + event.title

      recurrence_end_date = end_date < event.end_date ? end_date : event.end_date

      rrule.between(start_date, recurrence_end_date).each do |event_date|
        gen_event = event.dup
        gen_event.id = event.id
        gen_event.start_date = event_date
        gen_event.is_exception = false

        # check if event is cancelled or rescheduled
        event_exception = EventException.where("event_schema_id = ? AND exception_date = ?", gen_event.id, gen_event.start_date).first

        if event_exception.present?
          if EventException.statuses[event_exception.status] == EventException.statuses[:cancelled] # cancelled
            next
          else # resceduled
            gen_event.start_date = event_exception.start_date
            gen_event.end_date = event_exception.end_date
            gen_event.is_exception = true
          end
        end
        
        break gen_event
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_event_schema
      @event_schema = EventSchema.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_schema_params
      params.require(:event_schema).permit(:title, :description, :start_date, :end_date, :is_all_day, :is_recurring, :recurrence, :duration, :location, :calendar_id, :color, :startDate, :endDate, :group_ids, :event_schema_id)
    end
end
