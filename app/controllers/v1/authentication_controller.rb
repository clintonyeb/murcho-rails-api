class V1::AuthenticationController < V1::BaseController
  skip_before_action :authenticate_request!

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.email_confirmed?
        auth_token = JsonWebToken.encode({user_id: user.id})
        render json: {auth_token: auth_token}, status: :ok
      else
        render json: { error: 'Email is not verified. Please check your email and verify.' }, status: :unauthorized  
      end
    else
      render json: { error: 'Invalid username or password.' }, status: :unauthorized
    end
  end
end
