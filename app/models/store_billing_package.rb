class StoreBillingPackage < ApplicationRecord
  belongs_to :billable, polymorphic: true
end
