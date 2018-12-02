class V1::PersonGroupsController < V1::BaseController
  before_action :set_person_group, only: [:show, :update, :destroy]

  # GET /person_groups
  def index
    @person_groups = PersonGroup.all

    render json: @person_groups
  end

  # GET /person_groups/1
  def show
    render json: @person_group
  end

  # POST /person_groups
  def create
    @person_group = PersonGroup.new(person_group_params)

    if @person_group.save
      render json: @person_group, status: :created, location: @person_group
    else
      render json: @person_group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /person_groups/1
  def update
    if @person_group.update(person_group_params)
      render json: @person_group
    else
      render json: @person_group.errors, status: :unprocessable_entity
    end
  end

  # DELETE /person_groups/1
  def destroy
    @person_group.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person_group
      @person_group = PersonGroup.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def person_group_params
      params.require(:person_group).permit(:person_id, :group_id)
    end
end
