# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# 使用 Session 中间件，并将前面生成的密钥用于加密
use Rack::Session::Cookie, secret: File.read(".session.key"), same_site: :strict, max_age: 86400

# 挂载 Sidekiq Web UI
require 'sidekiq/web'

# 如果你需要限制 Sidekiq Web UI 的访问权限，推荐添加身份验证，如下所示：
# authenticate :user, ->(u) { u.admin? } do
#   mount Sidekiq::Web => '/sidekiq'
# end

# 启动 Rails 应用
run Rails.application

# 确保 Sidekiq Web UI 和 Rails 应用程序同时运行
map "/sidekiq" do
  run Sidekiq::Web
end
