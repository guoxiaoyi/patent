class RechargeType < ApplicationRecord
  acts_as_paranoid
  
  has_many :transactions, as: :transactionable, dependent: :destroy

  validates :name, :price, :discount, :amount, presence: true
end
