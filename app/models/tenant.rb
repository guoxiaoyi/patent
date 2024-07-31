class Tenant < ApplicationRecord
  include Deductible
  include Rechargeable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :users
  has_many :transactions, as: :account, dependent: :destroy

  enum billing_mode: { shared: 0, isolated: 1 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null,
         authentication_keys: [:phone]

  validates :name, presence: true
  validates :password, confirmation: true
  validates :subdomain, uniqueness: true, allow_blank: true
  validates :domain, uniqueness: true, allow_blank: true
  validate :subdomain_or_domain_present

  # 租户购买资源包
  # def purchase_resource_pack(resource_pack_type)
  #   resource_pack = ResourcePack.create(
  #     tenant: self,
  #     resource_pack_type: resource_pack_type,
  #     amount: resource_pack_type.amount,
  #     valid_from: Time.current,
  #     valid_to: Time.current + resource_pack_type.valid_days.days
  #   )

  #   Transaction.create({
  #     account: self,
  #     amount: resource_pack_type.amount,
  #     transaction_type: :resource_pack_purchase,
  #     transactionable: resource_pack,
  #     description: "Tenant purchased resource pack #{resource_pack_type.name}"}
  #   )
  # end

  # # 更新租户余额
  # def update_balance(amount)
  #   update(balance: balance + amount)
  # end

  private

  def subdomain_or_domain_present
    if subdomain.blank? && domain.blank?
      errors.add(:base, "Either subdomain or domain must be present")
    end
  end
end
