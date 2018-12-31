class V1::UsersController < V1::BaseController
  before_action :set_user, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request!, :only => [:create]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def get_user_info
    return invalid_authorization unless authorize(:admin)
    user = User.find_by(email: params[:email])
    render json: user
  end

  def get_actions_stats
    interval = params[:interval] || 'month'
    count = params[:count] || 19

    end_date = Time.now
    start_date = count.send(interval).ago
    interval_value = "1 #{interval}"

    label_query = "
    SELECT generate_series(timestamp ?, timestamp ?, interval ?) AS labels ORDER  BY 1;
    "

    series_query = "
    SELECT labels, count(e.created_at) AS events
    FROM  (SELECT generate_series(timestamp ?, timestamp ?, interval ?)) g(labels)
    LEFT   JOIN actions e ON e.created_at >= g.labels
    AND e.created_at <  g.labels + interval ?
    GROUP  BY 1
    ORDER  BY 1;
    "

    labels = Action.find_by_sql([label_query, start_date, end_date, interval_value]).pluck(:labels)
    actions_series = Action.find_by_sql([series_query, start_date, end_date, interval_value, interval_value]).pluck(:events)

    render json: {labels: labels, series: [actions_series], interval: interval, count: count, start_date: start_date, end_date: end_date}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:photo, :phone_number, :email, :access_level, :church_id, :password_digest, :salt, :full_name, :trash, :password)
    end
end
