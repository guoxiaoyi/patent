module SubFeatures
  class InventionSummaryJob < ApplicationJob
    queue_as :default

    def perform(conversation, step) 
      unless step.pending? || step.failed?
        Rails.logger.info "Step #{step.id} is not pending or failed, status: #{step.status}. Skipping execution."
        return
      end
      input = {
        messages: []
      }
      
      # 如果 step.sub_feature.prompt 存在且不为空，则添加 system 消息
      if step.sub_feature.prompt.present?
        # 获取初始prompt
        prompt = conversation.feature.prompt
        
        # 安全地替换所有占位符
        if conversation.metadata.present?
          # 定义所有需要替换的占位符及其对应的值
          replacements = {
            '${kind}' => conversation.metadata['kind'],
            '${problem}' => conversation.metadata['problem']
            # 可以在这里添加更多替换项
          }
          
          # 遍历并替换所有占位符
          replacements.each do |placeholder, value|
            prompt = prompt.gsub(placeholder, value.to_s) if value.present?
          end
        end

        input[:messages] << { role: 'system', content: prompt }
      end
      
      # 始终添加 user 消息
      sub_feature_keys = conversation.steps.where(status: 'completed').pluck(:feature_key)      
      input[:messages] << { role: 'user', content: conversation.messages.where(sub_feature_key: { '$in': sub_feature_keys }).map(&:content).join(' ') }

      tongyi = Tongyi.server(input)
  
      parser = EventStreamParser::Parser.new
      cumulative_message = ''
      total_output_tokens = 0
      input_tokens = 0
      request_id = ''
  
      # 首先创建一条空的 Message 记录，稍后逐步更新
      message = Message.create!(
        feature_key: conversation.feature.feature_key,
        sub_feature_key: step.sub_feature.feature_key,
        content: '',  # 初始为空
        output_tokens: total_output_tokens,
        input_tokens: input_tokens,
        conversation_id: conversation.id,
        user_id: conversation.user.id,
        request_id: request_id
      )

      
      begin
        step.update!(status: :processing)
        # 执行具体业务逻辑
        response_body = tongyi[:http].request(tongyi[:request]) do |response|
          response.read_body do |chunk|
            chunk.force_encoding('UTF-8')
            parser.feed(chunk) do |_type, data|
              parsed_data = JSON.parse(data) rescue {}
              if parsed_data.dig("output", "choices")
                # 处理逐步生成的消息块
                message_chunk = parsed_data["output"]["choices"].map { |choice| choice.dig("message", "content") }.compact.join(" ")
                cumulative_message += message_chunk
                total_output_tokens += parsed_data.dig("usage", "output_tokens") || 0
                input_tokens = parsed_data.dig("usage", "input_tokens") || input_tokens
                request_id = parsed_data["request_id"] || request_id
  
                # 广播消息到前端
                ActionCable.server.broadcast("conversation_channel_#{conversation.request_id}", { message: message_chunk, status: step.status, id: step.id, key: step.sub_feature.feature_key })
  
                # 每次解析出内容时，逐步更新 message 记录
                message.update!(
                  content: cumulative_message.strip,  # 更新消息内容
                  output_tokens: total_output_tokens, # 更新 token 计数
                  input_tokens: input_tokens,
                  request_id: request_id
                )
              else
                raise "#{parsed_data}"
              end
            end
          end
        end
        # 假设这里执行了业务逻辑并成功
        step.update!(status: :completed)
        ActionCable.server.broadcast("conversation_channel_#{conversation.request_id}", { status: step.status, id: step.id, key: step.sub_feature.feature_key })
      rescue => e
        # 如果执行失败，更新状态为 failed
        step.update!(status: :failed, error_message: e.message)
        Rails.logger.error "Step #{step.id} execution failed: #{e.message}"
        ActionCable.server.broadcast("conversation_channel_#{conversation.request_id}", { status: step.status, id: step.id, key: step.sub_feature.feature_key })
        # 可选择: 重试次数限制，Sidekiq 的默认重试机制将会处理
        raise e  # 让 Sidekiq 捕获异常并触发重试机制
      end
    end

    after_perform do |job|
      conversation, step = job.arguments

      conversation.dispatch_pending_steps
    end
  end
end
