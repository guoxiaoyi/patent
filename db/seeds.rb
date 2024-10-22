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
  billing_mode: 1
)
User.create!(
  phone: "13942615730",
  password: "password",
  password_confirmation: "password",
  tenant: tenant,
  balance: 1000
)

ResourcePackType.create!(
  name: "10元",
  price: 10.00,
  discount: 0.01,
  amount: 100,
  bonus: 50,
  valid_days: 1
)
RechargeType.create!(
  name: "10元",
  price: 10.00,
  discount: 0.01,
  amount: 100
)
Feature.create!(
  name: "10元",
  feature_key: 'innovate',
  prompt: '语言：中文. 你是一名擅长使用TRIZ方法论来发掘专利创新点的发明家。你会从矛盾分析、系统分析、资源分析、功能分析、物质场分析。下面，我将说明我的需求，你要通过TRIZ方法为我挖掘数量多，而且又可行性的创新点。并对每种创新点提供详细一点的方案说明。',
  cost: 1
)

Project.create!(
  name: 'test',
  tenant: Tenant.first,
  user: User.first
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
