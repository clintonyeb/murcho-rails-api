class V1::EventSchemasController < V1::BaseController
  before_action :set_event_schema, only: [:show, :update, :destroy]

  # GET /event_schemas
  def index
    start_date = Time.parse(params[:start_date]).utc 
    end_date = Time.parse(params[:end_date]).utc

    @event_schemas = EventSchema.joins(:calendar).where("church_id = ? AND start_date >= ? AND end_date <= ?", @current_user.church_id, start_date, end_date).select("event_schemas.id, title, start_date, color").order(created_at: :desc)

    render json: @event_schemas
  end

  # GET /event_schemas/1
  def show
    render json: @event_schema
  end

  # POST /event_schemas
  def create
    @event_schema = EventSchema.new(event_schema_params)
    
    # calculate end date from duration and start_date

    if @event_schema.end_date.blank?
      end_date = @event_schema.start_date + @event_schema.duration
      logger.debug end_date
      @event_schema.end_date = end_date
    end

    if @event_schema.save
      render json: @event_schema, status: :created
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_schema
      @event_schema = EventSchema.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_schema_params
      params.require(:event_schema).permit(:title, :description, :start_date, :end_date, :is_all_day, :is_recurring, :recurrence, :duration, :location, :calendar_id, :color)
    end
end
