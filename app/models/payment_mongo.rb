class PaymentMongo
  include Mongoid::Document
  include Mongoid::Timestamps
  field :code, type: String
  field :status, type: String
  belongs_to :user
  belongs_to :tenant
  belongs_to :paymentable
end
