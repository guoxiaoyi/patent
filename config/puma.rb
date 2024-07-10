directory '/www/wwwroot/patent/current'
rackup "/www/wwwroot/patent/current/config.ru"
environment 'production'

pidfile "/www/wwwroot/patent/shared/tmp/pids/puma.pid"
state_path "/www/wwwroot/patent/shared/tmp/sockets/puma.state"
stdout_redirect "/www/wwwroot/patent/shared/log/puma.stdout.log", "/www/wwwroot/patent/shared/log/puma.stderr.log", true

threads 4,16
bind "unix:///www/wwwroot/patent/shared/tmp/sockets/puma.sock"
workers 2
preload_app!

on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = ""
end
