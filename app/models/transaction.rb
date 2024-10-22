class Transaction < ApplicationRecord
  BILLING_TYPES = %w[recharge resource_pack_purchase gift].freeze
  
  belongs_to :account, polymorphic: true
  belongs_to :transactionable, polymorphic: true
  has_one :payment

  enum transaction_type: { deduct: 0, recharge: 1, resource_pack_purchase: 2, gift: 3 }
  
  scope :billings, -> { where(transaction_type: BILLING_TYPES) }
  scope :deductions, -> { where.not(transaction_type: BILLING_TYPES) }

end
