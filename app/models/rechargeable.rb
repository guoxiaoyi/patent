module Rechargeable
  extend ActiveSupport::Concern

  included do
    has_many :resource_packs, as: :owner, dependent: :destroy
  end

  # 充值或购买资源包
  # 根据提供的类型执行相应的操作，可以是购买资源包或充值
  # 
  # 参数:
  # - type: 操作类型，可以是ResourcePackType（资源包类型）或RechargeType（充值类型）
  # 
  # 返回值:
  # - 如果操作成功，返回true
  # - 如果类型无效，将错误信息添加到errors集合中，并返回false
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
      description: "够买资源包: #{resource_pack_type.name}"
    )
  end

  # 充值
  def recharge(recharge_type)
    txn = Transaction.create(
      account: self,
      amount: recharge_type.amount,
      transaction_type: :recharge,
      transactionable: recharge_type,
      description: "充值 #{recharge_type.amount} 星币"
    )
    update(balance: balance + recharge_type.amount)
    txn
  end
end
