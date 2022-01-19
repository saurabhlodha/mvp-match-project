class UserPolicy < ApplicationPolicy
  def deposit?
    user.buyer?
  end

  def reset?
    user.buyer?
  end
end