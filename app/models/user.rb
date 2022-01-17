class User < ApplicationRecord
  has_secure_password

  enum role: [:buyer, :seller], _default: :buyer

  validates :name, :deposit, :role, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validate :deposit_multiple_of_five

  has_many :products, foreign_key: 'seller_id'

  private

  def deposit_multiple_of_five
    unless self.deposit % 5 == 0
      self.errors.add(:deposit, 'must be multiple of 5')
    end
  end
end
