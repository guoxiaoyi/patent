class Api::V1::IdeasController < ApplicationController
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
        prompt: "语言：中文, 你是一名擅长使用TRIZ方法论来发掘专利创新点的发明家。你会从矛盾分析、系统分析、资源分析、功能分析、物质场分析。下面，我将说明我的需求，你要通过TRIZ方法为我挖掘数量多，而且又可行性的创新点。并对每种创新点提供详细一点的方案说明。\n
        运动手机"
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
          ActionCable.server.broadcast('idea_channel', data)
        end
        # response_body += convert_to_json(chunk)
      end
    end
  
    render json: { message: 'Signed up successfully.' }
  end

  private
  def history_params
    params.require(:idea).permit(:question, :answer)
  end
end
