class V1::ChurchesController < V1::BaseController
  before_action :set_church, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request!, :only => [:create]

  # GET /churches
  def index
    @churches = Church.all

    render json: @churches
  end

  # GET /churches/1
  def show
    render json: @church
  end

  # POST /churches
  def create
    @church = Church.new(church_params)

    if @church.save
      render json: @church, status: :created
    else
      render json: @church.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /churches/1
  def update
    if @church.update(church_params)
      render json: @church
    else
      render json: @church.errors, status: :unprocessable_entity
    end
  end

  # DELETE /churches/1
  def destroy
    @church.destroy
  end

  def church_info
    church_id = params[:church_id]
    church = Church.find(church_id)
    members_count = Person.where(church_id: church_id, membership_status: :member).count
    guests_count = Person.where(church_id: church_id, membership_status: :guest).count
    render json: {church: church, members: members_count, guests: guests_count} 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_church
      @church = Church.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def church_params
      params.require(:church).permit(:name, :location, :photo, :motto, :trash)
    end
end
