class Project < ApplicationRecord
  acts_as_paranoid
  default_scope { order(created_at: :desc) }

  belongs_to :customer, optional: true
  belongs_to :tenant
end
