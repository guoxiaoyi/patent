class InnovateConversationJob < ApplicationJob
  queue_as :default

  def perform(conversation, user)
    # 确保任务只执行一次，防止重复执行
    return if conversation.processing?

    # 设置 conversation 为 processing
    conversation.update!(processing: true)

    prompt = conversation.feature.prompt.gsub('${keywords}', conversation.metadata['keywords'])
    input = {
      messages: [
        { role: 'system', content: prompt },
        { role: 'user', content: conversation.title }
      ]
    }
    tongyi = Tongyi.server(input)

    parser = EventStreamParser::Parser.new
    cumulative_message = ''
    total_output_tokens = 0
    input_tokens = 0
    request_id = ''

    # 首先创建一条空的 Message 记录，稍后逐步更新
    message = Message.create!(
      feature_key: conversation.feature.feature_key,
      content: '',  # 初始为空
      output_tokens: total_output_tokens,
      input_tokens: input_tokens,
      conversation_id: conversation.id,
      user_id: user.id,
      request_id: request_id
    )

    begin
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
              ActionCable.server.broadcast("conversation_channel_#{conversation.request_id}", { message: message_chunk })

              # 每次解析出内容时，逐步更新 message 记录
              message.update!(
                content: cumulative_message.strip,  # 更新消息内容
                output_tokens: total_output_tokens, # 更新 token 计数
                input_tokens: input_tokens,
                request_id: request_id
              )
            end
          end
        end
      end
    rescue => e
      Rails.logger.error("Processing conversation #{conversation_id} failed: #{e.message}")
    ensure
      # 确保任务完成后，重置 processing 状态
      conversation.update!(processing: false)
    end
  end
end
