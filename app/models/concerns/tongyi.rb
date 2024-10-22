require 'net/http'
require 'json'
require 'uri'

class Tongyi
  def self.server(input)
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
      input: input,
      response_format: { type: 'json_object'},
      parameters: {
        result_format: 'message',
        incremental_output: true
      }
    })
    return { http: http, request: request }
  end
end
