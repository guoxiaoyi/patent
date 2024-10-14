class Tenant < ApplicationRecord
  include Deductible
  include Rechargeable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # mode 0: 企业, 1: 租户

  has_many :users
  has_many :projects
  has_many :customers
  has_many :transactions, as: :account, dependent: :destroy

  enum billing_mode: { shared: 0, isolated: 1 }
  enum mode: { company: 0, tenant: 1 }
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null,
         authentication_keys: [:phone]

  validates :name, presence: true
  validates :password, confirmation: true
  validates :domain, uniqueness: { scope: :subdomain, case_sensitive: false }, presence: true, if: :subdomain?
  validates :subdomain, presence: true, if: :tenant?
  validate :subdomain_or_domain_present

  private

  def subdomain_or_domain_present
    if subdomain.blank? && domain.blank?
      errors.add(:base, "Either subdomain or domain must be present")
    end
  end
end
