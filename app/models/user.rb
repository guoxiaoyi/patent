class User < ApplicationRecord
  include Deductible
  include Rechargeable

  acts_as_tenant(:tenant)

  belongs_to :tenant
  has_many :projects
  has_many :payments, dependent: :destroy
  has_many :transactions, as: :account, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist,
         authentication_keys: [:phone]

  validates_uniqueness_of :phone, scope: :tenant_id


  # 用户使用功能
  def use_feature(feature)
    target = tenant.shared? ? tenant : self
    if target.sufficient_balance?(feature.cost)
      target.deduct_amount(feature)
    else
      errors.add(:base, "Insufficient balance to use feature #{feature.name}")
      false
    end
  end

end
