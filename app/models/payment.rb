class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :tenant
  belongs_to :paymentable, polymorphic: true
  belongs_to :txn, class_name: 'Transaction', foreign_key: 'transaction_id', optional: true # 使用 txn 避免冲突
  
  after_initialize :set_default_status, if: :new_record?
  before_create :generate_code
  after_update :process_successful_payment, if: :saved_change_to_status?

  private

  def set_default_status
    self.status ||= 'pending'
  end

  # 生成唯一的纯数字 code，格式：8位随机数 + 时间戳
  def generate_code
    self.code = loop do
      random_code = "#{rand(10000000..99999999)}#{Time.now.to_i}" # 8位随机数 + 时间戳
      break random_code unless Payment.exists?(code: random_code)
    end
  end

  def process_successful_payment
    # 检查状态是否从 pending 更新为 success
    if status == 'success' && status_previously_was == 'pending'
      # 执行购买操作
      txn = user.purchase(paymentable)
      # 更新 transaction_id 为购买操作返回的 ID
      update_column(:transaction_id, txn.id)
    end
  end
end
