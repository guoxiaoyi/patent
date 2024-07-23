class UserBillingPackage < ApplicationRecord
  belongs_to :billable, polymorphic: true
end
