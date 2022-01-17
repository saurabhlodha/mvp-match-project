class Api::V1::SessionsController < Api::V1::BaseApiController
  skip_before_action :authenticate_request!, only: :authenticate_user

  def authenticate_user
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      render json: payload(user)
    else
      render json: { errors: ['Invalid Username/Password'] }, status: :unauthorized
    end
  end
end