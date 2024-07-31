class TenantManager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null,
         authentication_keys: [:phone]


  # 管理员赠送星币或资源包给用户或租户
  def gift(type, recipient, description = "Admin gift")
    if type.is_a?(Integer)
      # 赠送星币
      Transaction.create!(
        account: recipient,
        amount: type,
        transaction_type: :gift,
        transactionable: self,
        description: description
      )
      recipient.update_balance(type)
    elsif type.is_a?(ResourcePackType)
      # 赠送资源包
      resource_pack = recipient.resource_packs.create(
        resource_pack_type: type,
        amount: type.amount,
        valid_from: Time.current,
        valid_to: Time.current + type.valid_days.days
      )
      Transaction.create(
        account: recipient,
        amount: type.amount,
        transaction_type: :gift,
        transactionable: resource_pack,
        description: "Gifted resource pack #{type.name}"
      )
    else
      recipient.errors.add(:base, "Invalid gift type")
      false
    end
  end
        
end
