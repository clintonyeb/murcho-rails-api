class V1::AuthenticationController < V1::BaseController
  skip_before_action :authenticate_request!

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      auth_token = JsonWebToken.encode({user_id: user.id})
      render json: {auth_token: auth_token}, status: :ok
    else
      render json: {error: 'Login Unsuccessfull'}, status: :unauthorized
    end
  end
end
