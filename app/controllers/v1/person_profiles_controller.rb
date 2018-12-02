class V1::PersonProfilesController < V1::BaseController
  before_action :set_person_profile, only: [:show, :update, :destroy]

  # GET /person_profiles
  def index
    @person_profiles = PersonProfile.all

    render json: @person_profiles
  end

  # GET /person_profiles/1
  def show
    render json: @person_profile
  end

  # POST /person_profiles
  def create
    @person_profile = PersonProfile.new(person_profile_params)

    if @person_profile.save
      render json: @person_profile, status: :created, location: @person_profile
    else
      render json: @person_profile.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /person_profiles/1
  def update
    if @person_profile.update(person_profile_params)
      render json: @person_profile
    else
      render json: @person_profile.errors, status: :unprocessable_entity
    end
  end

  # DELETE /person_profiles/1
  def destroy
    @person_profile.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person_profile
      @person_profile = PersonProfile.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def person_profile_params
      params.require(:person_profile).permit(:date_of_birth, :relation_status, :gender, :person_id, :address, :profession)
    end
end
