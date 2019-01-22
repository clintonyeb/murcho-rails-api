class ApplicationController < ActionController::API
  before_action :authenticate_request!
  attr_reader :current_user
  
  protected
    def authenticate_request!
      if !payload || !JsonWebToken.valid_payload(payload.first)
        return invalid_authentication
      end

      load_current_user!
      invalid_authentication unless @current_user
    end

    def invalid_authentication
      render json: {error: 'Could not authenticate your request.'}, status: :unauthorized
    end

    def invalid_authorization
      render json: {error: 'You are not authorized to perform your request.'}, status: :unauthorized

    end

    def set_pagination
      @size = params.has_key?(:size) ? params[:size].to_i : 25
      @page = params.has_key?(:page) ? params[:page].to_i : 1
      @order = params.has_key?(:order) ? params[:order] : "updated_at"
      @sort = params.has_key?(:sort) ? params[:sort] : "DESC"
      @offset = (@page-1) * @size
    end

    def authorize(level)
      User.access_levels[@current_user.access_level] <= User.access_levels[level]
    end

    def verify_recaptcha(token)
      url = 'https://www.google.com/recaptcha/api/siteverify'      
      data = {
        secret: Rails.application.secrets.CAPTCHA_SECRET_KEY,
        response: token,
        remoteip: request.remote_ip
      }
      
      Http.make_https_request(url, data)
    end

  private
    def payload
      auth_header = request.headers['Authorization']
      token = auth_header.split(' ').last
      JsonWebToken.decode(token)
      rescue
        nil
    end

    def load_current_user!
      @current_user = User.find_by(id: payload[0]['user_id'])
    end
end
