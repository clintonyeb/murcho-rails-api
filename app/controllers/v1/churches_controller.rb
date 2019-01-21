class V1::ChurchesController < V1::BaseController
  before_action :set_church, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request!, :only => [:create, :local_churches, :delete_local_church, :show]

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

    if params[:'g-recaptcha-response'].present?
      response = verify_recaptcha(params[:'g-recaptcha-response'])
      if not response["success"]
        return (render json: { error: 'Could not verify captcha' }, status: :unprocessable_entity)
      end
    end

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

  def local_churches
    churches = Church.where(head_office_id: params[:church_id])
    render json: churches
  end

  def delete_local_church
    church = Church.find(params[:church_id])
    church.destroy
    render json: church
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_church
      @church = Church.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def church_params
      params.require(:church).permit(:name, :location, :photo, :motto, :trash, :head_office_id, :'g-recaptcha-response')
    end
end
