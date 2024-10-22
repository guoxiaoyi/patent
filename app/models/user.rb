class User < ApplicationRecord
  include Deductible
  include Rechargeable
  include Messageable

  acts_as_tenant(:tenant)

  belongs_to :tenant
  has_many :projects
  has_many :conversations
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
  def use_feature(conversation)
    target = tenant.shared? ? tenant : self
    # 检查用户的余额是否足够支付功能的费用
    if target.sufficient_balance?(conversation.feature.cost) 
      target.deduct_amount(conversation.feature)         # 扣费
      result = conversation.feature.use(conversation)    # 调用 feature 中的 use 方法，执行特定的业务逻辑      
      result                                             # 根据业务逻辑处理结果，可以执行后续操作或返回结果
    else
      errors.add(:base, "Insufficient balance to use feature #{feature.name}")
      false
    end
  end
end
