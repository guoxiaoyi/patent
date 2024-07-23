class User < ApplicationRecord
  acts_as_tenant(:tenant)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist,
         authentication_keys: [:phone]

  validates_uniqueness_of :phone, scope: :tenant_id
  
end
