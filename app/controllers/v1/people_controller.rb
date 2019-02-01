class V1::PeopleController < V1::BaseController
  before_action :set_person, only: [:show, :update, :destroy]
  before_action :set_pagination, only: [:index, :get_people_for_group, :search_people, :filter_search_people, :get_people_with_filter]
  skip_before_action :authenticate_request!, :only => [:app_feedback]

  # GET /people
  def index
    @people = Person.includes(:groups).joins("LEFT JOIN person_details ON people.id = person_details.person_id").where(church_id: @current_user.church_id).offset(@offset).limit(@size).order(@order => @sort).select("people.*, email, cell_phone_1")
    render json: @people, :include => {:groups => {:only => [:id, :name]}}
  end

  def total_people
    count = Person.where(church_id: @current_user.church_id).count
    render json: count
  end

  # GET /people/1
  def show
    render json: @person, :include => {:groups => {:only => [:id, :name]}}
  end

  # POST /people
  def create
    @person = Person.new(person_params)
    @person.church_id = @current_user.church_id

    if @person.save
      render json: @person, :include => {:groups => {:only => [:id, :name]}}, status: :created
    else
      render json: {error: @person.errors.full_messages.first}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/1
  def update
    if @person.update(person_params)
      render json: @person, :include => {:groups => {:only => [:id, :name]}}
      ThumbnailJob.perform_later(@person.id)
    else
      render json: {error: @person.errors.full_messages.first}, status: :unprocessable_entity
    end
  end

  # DELETE /people/1
  def destroy
    @person.destroy
  end

  def get_people_for_group
    person_groups = Person.joins("INNER JOIN person_groups ON person_groups.person_id=people.id").where("people.church_id=? AND person_groups.group_id=?", @current_user.church_id, params[:id]).offset(@offset).limit(@size).order(@order => @sort)
    render json: person_groups
  end

  def add_person_to_group
    person_group = PersonGroup.new(person_id: params[:person_id], group_id: params[:group_id])

    if person_group.save
      person = Person.find_by(id: params[:person_id])
      render json: person, status: :created
    else
      render json: {error: person_group.errors.full_messages.first}, status: :unprocessable_entity
    end
  end

  def search_people
    search_query = "#{params[:query]}%"
    order = "first_name"
    sort = "ASC"
    limit = 10

    people = Person.where("people.church_id = ? AND (LOWER(first_name) LIKE (?) OR LOWER(last_name) LIKE (?))", @current_user.church_id, search_query, search_query).limit(limit).order(order => sort).select(:id, :first_name, :last_name, :photo)
    
    render json: people
  end

  def filter_search_people
    search_query = "#{params[:query]}%"

    people = Person.includes(:groups).joins("LEFT JOIN person_details ON people.id = person_details.person_id").where("people.church_id = ? AND (LOWER(first_name) LIKE (?) OR LOWER(last_name) LIKE (?))", @current_user.church_id, search_query, search_query).offset(@offset).limit(@size).order(@order => @sort).select("people.*, email, cell_phone_1")
    
    render json: people, :include => {:groups => {:only => [:id, :name]}}
  end

  def add_people_to_groups
    people = params[:people]
    groups = params[:groups]

    people.each do |person|
      groups.each do |group|
        PersonGroup.create(person_id: person, group_id: group)
      end
    end

    render json: {status: true}, status: :created
  end

  def remove_person_groups
    person_group = PersonGroup.find_by(person_id: params[:person_id], group_id: params[:group_id])
    person_group.destroy
    
    person = Person.joins("LEFT JOIN person_details ON people.id = person_details.person_id").find(params[:person_id]).select("people.*, email, cell_phone_1")
    render json: person, :include => {:groups => {:only => [:id, :name]}}
  end

  def sign_url_for_upload
    render json: CloudStorage.sing_url(params[:file_name], params[:content_type])
  end

  def send_sms
    SmsJob.perform_later(@current_user.church_id, params[:person_ids], params[:message])
  end

  def send_mail
    PersonMailer.with(person_ids: params[:person_ids], subject: params[:subject], message: params[:message], church_id: @current_user.church_id).send_mail.deliver_later
  end

  def bulk_delete
    people_ids = params[:people_ids]
    people_ids.each do |id|
      person = Person.find(id)
      person.destroy
    end

    render json: {status: true}
  end

  def bulk_export
    file_url = ExportPeople.export(params[:export_format], @current_user.church_id, params[:people_ids])
    render json: {file_url: file_url, status: true}
  end

  def bulk_import
    ImportPeople.do_import(params[:file_url], @current_user.church_id)
  end

  def get_people_with_filter
    filters = params[:filters]
    query, data = build_filter_query(filters)

    @people = Person.includes(:groups).joins("LEFT JOIN person_details ON people.id = person_details.person_id").where(query, *data).offset(@offset).limit(@size).order(@order => @sort).select("people.*, email, cell_phone_1")
    render json: @people, :include => {:groups => {:only => [:id, :name]}}
  end

  def get_updates
    people = Person.where(church_id: @current_user.church_id).select(:id, :first_name, :last_name, :thumbnail, :photo, :membership_status, :date_joined).limit(10).order(updated_at: :desc)
    render json: people
  end

  def get_people_stats
    interval = params[:interval] || 'month'
    count = params[:count].to_i || 19

    end_date = Time.now
    start_date = count.send(interval).ago
    interval_value = "1 #{interval}"

    label_query = "
    SELECT generate_series(timestamp ?, timestamp ?, interval ?) AS labels ORDER  BY 1;
    "

    series_query = "
    SELECT labels, count(e.created_at) AS events
      FROM (SELECT generate_series(timestamp ?, timestamp ?, interval ?) AS labels) g(labels)
      LEFT JOIN people e ON e.created_at >= g.labels
      AND e.created_at <  g.labels + interval ?
      AND e.membership_status = ?
      GROUP  BY 1
      ORDER  BY 1;
    "

    labels = Person.find_by_sql([label_query, start_date, end_date, interval_value]).pluck(:labels)
    member_series = Person.find_by_sql([series_query, start_date, end_date, interval_value, interval_value, Person.membership_statuses[:member]]).pluck(:events)
    guest_series = Person.find_by_sql([series_query, start_date, end_date, interval_value, interval_value, Person.membership_statuses[:guest]]).pluck(:events)
    former_series = Person.find_by_sql([series_query, start_date, end_date, interval_value, interval_value, Person.membership_statuses[:former]]).pluck(:events)

    render json: {labels: labels, series: [member_series, guest_series, former_series], interval: interval, count: count, start_date: start_date, end_date: end_date}
  end

  def app_feedback
    app_feedback = AppFeedback.new(email: params[:email])

    if app_feedback.save
      render json: {success: true}, status: :ok
    else
      render json: {error: "Error adding your feedback."}, status: :unprocessable_entity
    end
  end

  def update_person_details
    person_detail = PersonDetail.find_or_create_by(person_id: params[:person_id])
    if person_detail.update(person_details_params)
      if params[:photo]
        ThumbnailJob.perform_later(params[:person_id])
      end

      render json: {success: true}, status: :ok
    else
      render json: {error: person_detail.errors.full_messages.first}, status: :unprocessable_entity
    end
  end

  def get_person_details
    person_detail = PersonDetail.find_or_create_by(person_id: params[:person_id])
    render json: person_detail
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def person_params
      params.require(:person).permit(:first_name, :last_name, :photo, :phone_number, :email, :membership_status, :church_id, :trash, :date_joined, :people, :groups, :person_id, :group_id, :thumbnail, :people_ids, :export_format, :filters, :file_url)
    end

    def person_details_params
      params.permit(:person_id, :other_names, :date_of_birth, :place_of_birth, :age, :day_born, :gender, :house_number, :street_name, :location, :hometown, :hometown_address, :education_level, :occupation, :cell_phone_1, :cell_phone_2, :email, :photo, :date_of_baptism, :place_of_baptism, :pastor_or_ministry,:confirmation_date, :place_of_confirmation, :communicant_status, :generational_group, :interest_group, :special_interests, :position_in_church,:church_position_period, :name_of_mother, :name_of_father, :marital_status, :name_of_spouse, :spouse_contact, :names_of_children)
    end

    def build_filter_query(filters)
      data = []
      query = "true "

      filters[:fields].each do |field|
        query += "AND (NOT(person_details.#{field} IS NULL OR person_details.#{field} = ''))"
      end

      if filters[:date_joined][:start_joined].present?
        query += "AND people.date_joined > ? "
        data.push(filters[:date_joined][:start_joined])
      end

      if filters[:date_joined][:end_joined].present?
        query += "AND people.date_joined < ? "
        data.push(filters[:date_joined][:end_joined])
      end

      if filters[:groups].present?
        people_ids = PersonGroup.distinct.where("group_id IN (?)", filters[:groups].map { |g| g[:id] }).select(:person_id)

        query += "AND people.id IN (?) "
        data.push(people_ids)
      end

      if filters[:name].present?
        search = "#{filters[:name]}%"
        query += "AND (LOWER(first_name) LIKE (?) OR LOWER(last_name) LIKE (?)) "
        data.push(search)
        data.push(search)
      end

      query += " AND people.church_id = ? "
      data.push(@current_user.church_id)

      return query, data
    end
end
