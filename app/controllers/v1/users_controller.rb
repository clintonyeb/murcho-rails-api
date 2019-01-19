class V1::UsersController < V1::BaseController
  before_action :set_user, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request!, :only => [:create, :forgot_password, :reset_password, :confirm_email]

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
      PersonMailer.with(user: @user).send_confirmation_email.deliver_later
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
    count = params[:count].to_i || 19

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

  def confirm_email
    email_token = params[:token].to_s
    user = User.find_by(email_confirmed_token: email_token)

    if user.present? && user.confirmation_token_valid?
      user.mark_as_confirmed!
      PersonMailer.with(user: user).send_welcome.deliver_later
      render json: { status: 'User confirmed successfully' }, status: :ok
    else
      render json: { error: 'Could not verify email address associated with this account.'}, status: :not_found
    end
  end

  def forgot_password
    email = params[:email]

    if email.blank?
      return render json: {error: 'Email not present'}
    end

    user = User.find_by(email: email)
    if user.present? && user.email_confirmed?
      user.generate_password_token!
      PersonMailer.with(user: user).send_password_reset.deliver_later
      render json: {status: 'ok'}, status: :ok
    else
      render json: {error: ['Email address not found. Please check and try again.']}, status: :not_found
    end

  end

  def reset_password
    if !params[:password].present?
      render json: {error: 'Password not present'}, status: :unprocessable_entity
      return
    end

    password_token = params[:token].to_s
    user = User.find_by(reset_password_token: password_token)

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        PersonMailer.with(user: user).password_reset_confirmation.deliver_later
        render json: {status: 'ok'}, status: :ok
      else
        render json: {error: user.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {error: "Token has expired. Please request new password reset link"}, status: :unprocessable_entity
    end
    
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
