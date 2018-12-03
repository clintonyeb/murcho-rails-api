class V1::EventSchemasController < V1::BaseController
  before_action :set_event_schema, only: [:show, :update, :destroy]

  # GET /event_schemas
  def index
    @event_schemas = EventSchema.all

    render json: @event_schemas
  end

  # GET /event_schemas/1
  def show
    render json: @event_schema
  end

  # POST /event_schemas
  def create
    @event_schema = EventSchema.new(event_schema_params)

    if @event_schema.save
      render json: @event_schema, status: :created
    else
      render json: @event_schema.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /event_schemas/1
  def update
    if @event_schema.update(event_schema_params)
      render json: @event_schema
    else
      render json: @event_schema.errors, status: :unprocessable_entity
    end
  end

  # DELETE /event_schemas/1
  def destroy
    @event_schema.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_schema
      @event_schema = EventSchema.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_schema_params
      params.require(:event_schema).permit(:title, :description, :start_date, :end_date, :is_all_day, :is_recurring, :recurrence, :duration, :location, :calendar_id)
    end
end
