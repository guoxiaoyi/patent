class Transaction < ApplicationRecord
  belongs_to :account, polymorphic: true
  belongs_to :transactionable, polymorphic: true
  has_one :payment

  enum transaction_type: { deduct: 0, recharge: 1, resource_pack_purchase: 2, gift: 3 }
end
