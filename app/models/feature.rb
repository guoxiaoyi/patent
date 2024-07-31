class Feature < ApplicationRecord
  has_many :transactions, as: :transactionable, dependent: :destroy
end
