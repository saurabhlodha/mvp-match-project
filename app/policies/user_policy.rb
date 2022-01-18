class UserPolicy < ApplicationPolicy
  def deposit?
    user.buyer?
  end
end