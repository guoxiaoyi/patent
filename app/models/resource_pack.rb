class ResourcePack < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :resource_pack_type
  has_many :transactions, as: :transactionable, dependent: :destroy
end
