# Api::V1::BaseApiController
class Api::V1::BaseApiController < ActionController::Base
  protected

  def payload(user)
    return nil unless user and user.id
    {
      auth_token: JsonWebToken.encode({ user_id: user.id }),
      user: user
    }
  end
end
