class UserBalance < ApplicationRecord
  belongs_to :billable, polymorphic: true
end
