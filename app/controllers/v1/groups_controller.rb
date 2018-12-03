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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:name)
    end
end
