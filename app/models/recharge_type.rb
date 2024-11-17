class RechargeType < ApplicationRecord
  acts_as_paranoid
  include RuleEvaluator

  
  has_many :transactions, as: :transactionable, dependent: :destroy

  validates :name, :price, :discount, :amount, presence: true
  
end
