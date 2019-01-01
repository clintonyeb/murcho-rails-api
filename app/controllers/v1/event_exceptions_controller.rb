class V1::EventExceptionsController < V1::BaseController
  before_action :set_event_exception, only: [:show, :update, :destroy]

  # GET /event_exceptions
  def index
    @event_exceptions = EventException.all

    render json: @event_exceptions
  end

  # GET /event_exceptions/1
  def show
    render json: @event_exception
  end

  # POST /event_exceptions
  def create
    if params[:is_exception]
      event_exception = EventException.where(event_schema_id: params[:event_schema_id], start_date: params[:exception_date]).first
      event_exception.start_date = params[:start_date]
    else
      old_exceptions = EventException.where(event_schema_id: params[:event_schema_id], exception_date: params[:exception_date]).destroy_all
      event_exception = EventException.new(event_exception_params)
    end
 
    if event_exception.save
      render json: event_exception, status: :created
    else
      render json: event_exception.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /event_exceptions/1
  def update
    if @event_exception.update(event_exception_params)
      render json: @event_exception
    else
      render json: @event_exception.errors, status: :unprocessable_entity
    end
  end

  # DELETE /event_exceptions/1
  def destroy
    @event_exception.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_exception
      @event_exception = EventException.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_exception_params
      params.require(:event_exception).permit(:event_schema_id, :exception_date, :status, :start_date, :end_date, :is_exception)
    end
end
