module RuleEvaluator
  extend ActiveSupport::Concern

  # 定义支持的规则枚举
  RULES = {
    first_recharge: "首次充值用户",
    inactive_days: "未活跃用户",
    new_user: "新用户"
  }.freeze

  included do
    # 检查某用户是否符合展示条件
    def visible_to_user?(user)
      return true if rules.blank? # 没有规则的包默认展示

      rules.any? do |rule|
        evaluate_rule(rule.to_sym, user)
      end
    end

    # 返回所有对用户可见的包
    def self.available_to_user(user)
      all.select { |record| record.visible_to_user?(user) }
    end
  end

  private

  # 处理单条规则
  def evaluate_rule(rule, user)
    case rule
    when :first_recharge
      user.payments.where(status: 'success').empty? # 无交易记录
    when :inactive_days
      last_transaction = user.transactions.order(created_at: :desc).first
      last_transaction.nil? || last_transaction.created_at <= 15.days.ago
    when :new_user
      user.created_at >= 30.days.ago # 用户30天内注册
    else
      false # 未知规则
    end
  end
end
