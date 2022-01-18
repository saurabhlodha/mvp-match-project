FactoryBot.define do
  factory :product do
    seller
    product_name { Faker::Lorem.word }
    amount_available { Faker::Number.between(from: 1, to: 50) }
    cost { Faker::Number.between(from: 1, to: 50) * 5 }
  end
end
