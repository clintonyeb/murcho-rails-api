class V1::PeopleController < V1::BaseController
  before_action :set_person, only: [:show, :update, :destroy]
  before_action :set_pagination, only: [:index, :get_people_for_group, :search_people]

  # GET /people
  def index
    @people = Person.where(church_id: @current_user.church_id).offset(@offset).limit(@size).order(@order => @sort)
    render json: @people, :include => {:groups => {:only => [:id, :name]}}
  end
  # .includes => {:groups => {:only => :name}}

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
      render json: person_group.errors, status: :unprocessable_entity
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
