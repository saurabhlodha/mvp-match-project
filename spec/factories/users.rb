FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'ZeUoCDyrFof3' }
    name { Faker::Name.name }
    deposit { Faker::Number.between(from: 1, to: 50) * 5 }
  end

  factory :seller, parent: :user do
    role { 'seller' }
  end

  factory :buyer, parent: :user do
    role { 'buyer' }
    deposit { Faker::Number.between(from: 1, to: 50) * 5 }
  end
end
