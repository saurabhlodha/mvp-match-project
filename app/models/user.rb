class User < ApplicationRecord
  has_secure_password

  enum role: [:buyer, :seller], _default: :buyer

  validates :name, :deposit, :role, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
end
