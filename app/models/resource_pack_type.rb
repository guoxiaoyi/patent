class ResourcePackType < ApplicationRecord
  acts_as_paranoid
  include RuleEvaluator

  has_many :resource_packs

  validates :name, :price, :discount, :amount, :valid_days, presence: true
end
