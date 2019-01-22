class V1::AuthenticationController < V1::BaseController
  skip_before_action :authenticate_request!

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.email_confirmed?
        auth_token = JsonWebToken.encode({user_id: user.id})
        return (render json: {auth_token: auth_token}, status: :ok)
      else
        return (render json: { error: 'Your email is not verified. Please check and verify your email.' }, status: :unauthorized)  
      end
    else
      return (render json: { error: 'Invalid username or password entered.' }, status: :unauthorized)
    end
  end

  def session
    logger.debug "In session action...."
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      # logger.debug user.email
      if user.email_confirmed?
        # logger.debug user.email 
        session[:user_id] = user.id
        return (render json: {success: true, user_id: user.id, email: user.email, full_name: user.full_name}, status: :ok)
      else
        return (render json: { error: 'Your email is not verified. Please check and verify your email.' }, status: :unauthorized)  
      end
    else
      return (render json: { error: 'Invalid username or password entered.' }, status: :unauthorized)
    end
  end
end
