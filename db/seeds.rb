# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

TenantManager.create(phone: 13942615730)

tenant = Tenant.create!(
  phone: '13942615730',
  name: "Example Tenant",
  subdomain: "example",
  domain: "localhost",
)
User.create!(
  phone: "13942615730",
  password: "password",
  password_confirmation: "password",
  tenant: tenant
)

ResourcePackType.create!(
  name: "10元",
  price: 10.00,
  discount: 0.01,
  amount: 100,
  valid_days: 30
)
RechargeType.create!(
  name: "10元",
  price: 10.00,
  discount: 0.01,
  amount: 100
)

# ResourcePackType.create!(
#   name: "20元",
#   price: 20.00,
#   amount: 200,
#   valid_days: 3
# )
# ResourcePackType.create!(
#   name: "30元",
#   price: 30.00,
#   amount: 300,
#   valid_days: 5
# )

# RechargeType.create!(
#   name: "10元",
#   price: 10.00,
#   amount: 100
# )
# RechargeType.create!(
#   name: "20元",
#   price: 20.00,
#   amount: 200
# )
# RechargeType.create!(
#   name: "30元",
#   price: 30.00,
#   amount: 300
# )

# Feature.create!(
#   name: "聊天",
#   cost: 140
# )
# Feature.create!(
#   name: "提问",
#   cost: 50
# )
