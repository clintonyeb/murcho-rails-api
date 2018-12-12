class V1::GroupsController < V1::BaseController
  before_action :set_group, only: [:show, :update, :destroy]
  before_action :set_pagination, only: [:index]

  # GET /groups
  def index
    @groups = Group.where(church_id: @current_user.church_id).offset(@offset).limit(@size).order(@order => @sort).select("groups.*, (SELECT COUNT(person_groups.id) FROM person_groups WHERE person_groups.group_id=groups.id) as people_count")
    render json: @groups
  end

  def total_groups
    count = Group.where(church_id: @current_user.church_id).count
    render json: count
  end

  # GET /groups/1
  def show
    render json: @group
  end

  # POST /groups
  def create
    @group = Group.new(group_params)
    @group.church_id = @current_user.church_id

    if @group.save
      render json: @group, status: :created
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
  end

  def search_groups
    search_query = "#{params[:query]}%"
    order = "name"
    sort = "ASC"
    limit = 10

    groups = Group.where("church_id = ? AND LOWER(name) LIKE (?)", @current_user.church_id, search_query).limit(limit).order(order => sort).select(:id, :name, :description)
    
    render json: groups
  end

  def send_sms
    people_ids = PersonGroup.where(group_id: params[:group_id]).select(:id, :person_id).to_a.map {|p| p[:person_id]}
    SmsJob.perform_later(@current_user.church_id, people_ids, params[:message])
  end

  def send_mail
    people_ids = PersonGroup.where(group_id: params[:group_id]).select(:id, :person_id).to_a.map {|p| p[:person_id]}
    PersonMailer.with(person_ids: people_ids, subject: params[:subject], message: params[:message], church_id: @current_user.church_id).send_mail.deliver_later
  end

  def bulk_export
    people_ids = PersonGroup.where(group_id: params[:group_id]).select(:id, :person_id).to_a.map {|p| p[:person_id]}
    file_url = ExportPeople.export(params[:export_format], @current_user.church_id, people_ids)
    render json: {file_url: file_url, status: true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:name, :description)
    end
end
