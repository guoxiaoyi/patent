class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  validates :phone, presence: true, uniqueness: true
  validates :email, presence: false

  before_create :set_default_role
  ROLES = %w[user admin].freeze
  def generate_verification_code
    code = rand.to_s[2..7]
    p code
    self.verification_code = code
  end

  def verify_code(code)
    self.verification_code == code
  end

  def admin?
    role == 'admin'
  end

  private

  def set_default_role
    self.role ||= 'user'
  end
end
