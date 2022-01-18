class ProductPolicy < ApplicationPolicy
  attr_reader :user, :product

  def initialize(user, product)
    @user = user
    @product = product
  end

  def update?
    user.seller? && user.products.include?(product)
  end

  def destroy?
    user.seller? && user.products.include?(product)
  end

  def create?
    user.seller?
  end

  def buy?
    user.buyer?
  end
end
