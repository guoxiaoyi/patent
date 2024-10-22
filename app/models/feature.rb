class Feature < ApplicationRecord
  has_many :transactions, as: :transactionable, dependent: :destroy

  def use(conversation)
    method_name = "#{feature_key}_logic"  # 动态生成方法名
    if respond_to?(method_name, true)     # 检查是否存在该方法
      send(method_name, conversation)                   # 动态调用相应的方法
    else
      default_logic(conversation)                       # 如果方法不存在，调用默认逻辑
    end
  end


  # 各种不同的业务逻辑方法
  def innovate_logic(conversation)
    input = {
      messages: [
        { role: 'system', content: prompt },
        { role: 'user', content: conversation.title }
      ]
    }
    Tongyi.server(input)
  end

  def create_idea_logic(conversation)
    "This is the create_idea logic."
  end

  def analyze_system_logic(conversation)
    "This is the analyze_system logic."
  end

  # 当 feature_key 对应的方法不存在时调用
  def default_logic(conversation)
    input = {
      messages: [
        { role: 'system', content: prompt },
        { role: 'user', content: conversation.title }
      ]
    }
    Tongyi.server(input)
  end

end
