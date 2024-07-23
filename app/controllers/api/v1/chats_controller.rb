class Api::V1::ChatsController < ApplicationController
  include ActionController::Live

  before_action :authenticate_user!
  before_action :set_idea, only: %i[ show update destroy ]

  def create
    uri = URI('https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
  
    request = Net::HTTP::Post.new(uri.path, {
      'Content-Type' => 'application/json',
      'Accept' => 'text/event-stream',
      'X-DashScope-SSE' => 'enable',
      'Authorization' => "Bearer sk-43b69fa36af748c087400a23ad2ec1e2"
    })
    
    request.body = JSON.generate({
      model: 'qwen-turbo',
      input: {
        messages: [
          {
            role: 'system',
            content: '你是一个专业的写专利助手'
          },
          {
            role: 'user',
            content: '你还记得我之前 问的问题吗？'
          },
          {
            role: 'assistant',
            content: '是的，我记得。请告诉我你之前问的问题，我会尽力为你提供答案或解答。'
          },
          {
            role: 'user',
            content: '所以，我之前问你什么问题了？'
          },
          {
            role: 'assistant',
            content: '对不起，由于我是一个基于模型的聊天助手，我并没有记忆功能，无法回忆起具体的个人对话历史。但我可以根据当前的话题来提供帮助。如果你能再次告诉我你的问题，我会尽力回答。'
          }
        ]
      },
      parameters: {
        result_format: 'message',
        incremental_output: true
      }
    })
  
    response_body = ""
    parser = EventStreamParser::Parser.new

    http.request(request) do |response|
      response.read_body do |chunk|
        chunk.force_encoding('UTF-8')
        parser.feed(chunk) do |_type, data|
          # 在这里可以将chunk通过某种方式传递给前端，比如通过ActionCable或者SSE
          ActionCable.server.broadcast('chat_channel', data)
        end
        # response_body += convert_to_json(chunk)
      end
    end
    render_json(message: 'Signed up successfully.', data: { })
  end

  private
  def chat_params
    params.require(:chat).permit(:question)
  end
end
