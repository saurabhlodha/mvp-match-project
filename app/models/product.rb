class Product < ApplicationRecord
  validates :amount_available, :cost, :product_name, presence: true
  validates :product_name, uniqueness: true
  validate :cost_multiple_of_five
  belongs_to :seller, class_name: 'User', foreign_key: :seller_id

  private

  def cost_multiple_of_five
    unless self.cost % 5 == 0
      self.errors.add(:cost, 'must be multiple of 5')
    end
  end
end
