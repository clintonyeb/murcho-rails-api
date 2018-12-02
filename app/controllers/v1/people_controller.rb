class V1::PeopleController < V1::BaseController
  before_action :set_person, only: [:show, :update, :destroy]
  before_action :set_pagination, only: [:index]

  # GET /people
  def index
    @people = Person.where(church_id: @current_user.church_id).offset(@offset).limit(@size).order("#{@order} #{@sort}")
    render json: @people
  end

  def total_people
    count = Person.where(church_id: @current_user.church_id).count
    render json: count
  end

  # GET /people/1
  def show
    render json: @person
  end

  # POST /people
  def create
    @person = Person.new(person_params)

    if @person.save
      render json: @person, status: :created, location: @person
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/1
  def update
    if @person.update(person_params)
      render json: @person
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  # DELETE /people/1
  def destroy
    @person.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def person_params
      params.require(:person).permit(:first_name, :last_name, :photo, :phone_number, :email, :membership_status, :church_id, :trash, :date_joined)
    end
end