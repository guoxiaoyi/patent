module Rechargeable
  extend ActiveSupport::Concern

  included do
    has_many :resource_packs, as: :owner, dependent: :destroy
  end

  # 充值或购买资源包
  def purchase(type)
    if type.is_a?(ResourcePackType)
      purchase_resource_pack(type)
    elsif type.is_a?(RechargeType)
      recharge(type)
    else
      errors.add(:base, "Invalid type")
      false
    end
  end

  private

  # 购买资源包
  def purchase_resource_pack(resource_pack_type)
    resource_pack = resource_packs.create(
      resource_pack_type: resource_pack_type,
      amount: resource_pack_type.amount,
      valid_from: Time.current,
      valid_to: Time.current + resource_pack_type.valid_days.days
    )

    Transaction.create(
      account: self,
      amount: resource_pack_type.amount,
      transaction_type: :resource_pack_purchase,
      transactionable: resource_pack,
      description: "Purchased resource pack #{resource_pack_type.name}"
    )
  end

  # 充值
  def recharge(recharge_type)
    Transaction.create(
      account: self,
      amount: recharge_type.amount,
      transaction_type: :recharge,
      transactionable: recharge_type,
      description: "Recharged #{recharge_type.amount} stars"
    )
    update(balance: balance + recharge_type.amount)
  end
end
