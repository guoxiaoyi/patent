class Transaction < ApplicationRecord
  belongs_to :account, polymorphic: true
  belongs_to :transactionable, polymorphic: true

  enum transaction_type: { recharge: 0, deduct: 1, gift: 2, resource_pack_purchase: 3 }
end
