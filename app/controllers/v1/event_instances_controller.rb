class V1::EventInstancesController < V1::BaseController
  before_action :set_event_instance, only: [:show, :update, :destroy]

  # GET /event_instances
  def index
    @event_instances = EventInstance.all

    render json: @event_instances
  end

  # GET /event_instances/1
  def show
    render json: @event_instance
  end

  # POST /event_instances
  def create
    @event_instance = EventInstance.new(event_instance_params)

    if @event_instance.save
      render json: @event_instance, status: :created
    else
      render json: @event_instance.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /event_instances/1
  def update
    if @event_instance.update(event_instance_params)
      render json: @event_instance
    else
      render json: @event_instance.errors, status: :unprocessable_entity
    end
  end

  # DELETE /event_instances/1
  def destroy
    @event_instance.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_instance
      @event_instance = EventInstance.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_instance_params
      params.require(:event_instance).permit(:title, :description, :start_date, :end_date, :is_all_day, :duration, :location, :calendar_id, :event_schema_id)
    end
end
