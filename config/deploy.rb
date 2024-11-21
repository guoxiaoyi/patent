# config valid for current version and patch releases of Capistrano
lock "~> 3.19.1"

set :application, "patent"
set :repo_url, "git@github.com:guoxiaoyi/patent.git"

# 设置分支为 main
set :branch, 'main'

# 部署路径
set :deploy_to, "/www/wwwroot/patent"

# 关闭 assets precompile 和 manifest 备份
Rake::Task["deploy:assets:backup_manifest"].clear_actions
Rake::Task["deploy:assets:precompile"].clear_actions

# 禁用 assets precompile 阶段（可选）
set :assets_roles, []

# 共享文件和目录
append :linked_files, "config/database.yml", "config/master.key", "config/sidekiq.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage", "node_modules"

# 保留最近的 5 个发布版本
set :keep_releases, 5

# Puma 配置
set :puma_conf, "#{shared_path}/config/puma.rb"
set :puma_service_unit_name, 'puma_patent_production'

# Sidekiq 配置
set :sidekiq_config, "#{shared_path}/config/sidekiq.yml"
set :sidekiq_service_unit_name, "sidekiq_patent_production" # 默认服务名，需与 Systemd 中一致


# Puma 命令配置
namespace :puma do
  # 清除默认任务并动态定义
  %w[status restart start stop].each do |action|
    Rake::Task["puma:#{action}"].clear_actions if Rake::Task.task_defined?("puma:#{action}")

    desc "#{action.capitalize} Puma service"
    task action.to_sym do
      on roles(:app) do
        execute :systemctl, "#{action} #{fetch(:puma_service_unit_name)}"
      end
    end
  end
end

namespace :sidekiq do
  # 清除默认任务并动态定义
  %w[status restart start stop].each do |action|
    Rake::Task["sidekiq:#{action}"].clear_actions if Rake::Task.task_defined?("sidekiq:#{action}")

    desc "#{action.capitalize} sidekiq service"
    task action.to_sym do
      on roles(:app) do
        execute :systemctl, "#{action} #{fetch(:sidekiq_service_unit_name)}"
      end
    end
  end
end

# # 部署完成后清理旧版本
# namespace :deploy do
#   after :finishing, 'deploy:cleanup'

#   # 重启应用服务
#   desc "Restart application"
#   task :restart do
#     invoke 'puma:restart'
#     invoke 'sidekiq:restart'
#   end
#   after :publishing, :restart
# end
