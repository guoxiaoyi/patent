module Deductible
  extend ActiveSupport::Concern
  included do
    has_many :resource_packs, as: :owner, dependent: :destroy
  end

  def sufficient_balance?(cost)
    valid_resource_packs_sum + balance >= cost
  end
  def deduct_amount(transactionable)
    ActiveRecord::Base.transaction do
      remaining_amount = transactionable.feature.cost

      # 优先使用资源包余额，按过期时间排序
      resource_packs.order(:valid_to).each do |resource_pack|
        break if remaining_amount <= 0
        if resource_pack.amount > 0
          if resource_pack.amount >= remaining_amount
            resource_pack.update!(amount: resource_pack.amount - remaining_amount)
            create_deduction_transaction(-remaining_amount, resource_pack, transactionable)
            remaining_amount = 0
          else
            create_deduction_transaction(-resource_pack.amount, resource_pack, transactionable)
            remaining_amount -= resource_pack.amount
            resource_pack.update!(amount: 0)
          end
        end
      end

      # 使用账户余额
      if remaining_amount > 0
        if balance >= remaining_amount
          update!(balance: balance - remaining_amount)
          create_deduction_transaction(-remaining_amount, self, transactionable)
        else
          raise ActiveRecord::Rollback, "Insufficient balance"
        end
      end
    end
  end

  private
  def create_deduction_transaction(amount, source, transactionable)
    Transaction.create(
      account: self,
      amount: amount,
      transaction_type: :deduct,
      transactionable: source,
      description: "在 #{transactionable.project.name} 中, 使用 #{transactionable.feature.name} 功能, 对话名称: #{transactionable.title}, #{ source.class.name === 'User' ? "账户余额: #{self.balance}星币" : "资源包余额: #{source.amount}星币" }"
    )
  end

  def valid_resource_packs_sum
    resource_packs.available.sum(:amount)
  end
end
