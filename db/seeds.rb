# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

buyer_one = User.create(email: 'buyer1@example.com', password: 'password', name: 'John Doe', role: :buyer, deposit: 125)
buyer_two = User.create(email: 'buyer2@example.com', password: 'password', name: 'Jane Doe', role: :buyer, deposit: 60)

seller_one = User.create(email: 'seller1@example.com', password: 'password', name: 'Make Smith', role: :seller)
seller_two = User.create(email: 'seller2@example.com', password: 'password', name: 'Dave Baker', role: :seller)

seller_one.products.create(product_name: 'Still Water', cost: 5, amount_available: 10)
seller_one.products.create(product_name: 'Sparking Water', cost: 5, amount_available: 12)
seller_one.products.create(product_name: 'Coco Cola', cost: 15, amount_available: 19)
seller_one.products.create(product_name: 'Pepsi', cost: 10, amount_available: 8)
seller_one.products.create(product_name: 'Coffee', cost: 25, amount_available: 6)

seller_two.products.create(product_name: 'Doughnut', cost: 15, amount_available: 7)
seller_two.products.create(product_name: 'Pizza', cost: 45, amount_available: 4)
seller_two.products.create(product_name: 'Pasta', cost: 35, amount_available: 2)
seller_two.products.create(product_name: 'Chocolates', cost: 10, amount_available: 20)
