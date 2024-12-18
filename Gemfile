source "https://gems.ruby-china.com/"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.8", ">= 7.0.8.4"

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

gem 'httparty'

# 登录
gem 'devise'
gem 'devise-jwt'

# 解析流式返回数据
gem 'event_stream_parser'
# 多租户
gem 'acts_as_tenant'
# 配置文件
gem 'figaro'
# 美化表格
gem 'hirb'
# 分页
gem 'kaminari'
# 软删除
gem 'acts_as_paranoid'
# mongoDB
gem 'mongoid', '~> 7.0'

# 异步任务
gem 'sidekiq'
gem 'redis'
# 定时任务
gem 'whenever', require: false
# 搜索功能
gem 'ransack'

gem 'pandoc-ruby'
gem 'docx_templater'
gem 'docx'


gem 'rails-erd'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'capistrano', '~> 3.14'
  gem 'capistrano-rails', '~> 1.6'
  gem 'capistrano-rvm', '~> 0.1.2'
  gem 'capistrano-bundler', '~> 1.6'
  gem 'capistrano3-puma', '~> 5.0'
  gem 'capistrano-sidekiq'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
