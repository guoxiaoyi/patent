# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "log/cron_log.log"

#
every 4.hours do
  runner "ResourcePack.schedule_expiring_packs"
end

# 开发测试用
# every 1.minute do
#   runner "ResourcePack.schedule_expiring_packs", environment: 'development'
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
