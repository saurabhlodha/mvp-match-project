# Api::V1::BaseApiController
class Api::V1::BaseApiController < ActionController::Base
  before_action :authenticate_request!

  attr_reader :current_user
  helper_method :current_user

  def authenticate_user
    user = User.find_for_database_authentication(email: params[:email])
    if user.valid_password?(params[:password])
      render json: payload(user)
    else
      render json: {
        errors: ['Invalid Username/Password'] }, status: :unauthorized
    end
  end

  protected

  def authenticate_request!
    unless user_id_in_token?
      render json: {
        errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end

    @current_user = User.find(auth_token[:user_id])
    rescue JWT::VerificationError, JWT::DecodeError
    render json: {  errors: ['Not Authenticated'] }, status: :unauthorized
  end

  def payload(user)
    return nil unless user && user.id
    {
      auth_token: JsonWebToken.encode({ user_id: user.id }),
      user: user
    }
  end

  private

  def http_token
    @http_token ||= if request.headers['Authorization'].present?
                      request.headers['Authorization'].split(' ').last
                    end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end

  def payload(user)
    return nil unless user && user.id
    {
      auth_token: ::JsonWebToken.encode(user_id: user.id),
      user: user.as_json
    }
  end

  def current_user
    @current_user || User.first
  end
end
