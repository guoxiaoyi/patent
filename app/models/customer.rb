class Customer < ApplicationRecord
  belongs_to :tenant
  belongs_to :user
end
