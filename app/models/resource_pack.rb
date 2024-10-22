class ResourcePack < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :resource_pack_type
  has_many :transactions, as: :transactionable, dependent: :destroy

  before_update :handle_empty_status, if: :active?
  enum status: { active: 0, expired: 1, empty: 2 }
  
  EXPIRE_TIME = 4.hours

  scope :available, -> {
    where('valid_to > ?', Time.current)
      .where('amount > ?', 0)
      .where(status: statuses[:active])
      .order(valid_to: :asc, created_at: :desc)
  }

  # 计算到 valid_to 的剩余天数
  def remaining_days
    return 0 if valid_to.past?
    ((valid_to.to_date - Date.current).to_i)
  end

  # 查找即将过期的资源包
  def self.schedule_expiring_packs
    redis = Redis.new
    where("valid_to <= ? AND valid_to > ? AND status = ?", 
      EXPIRE_TIME.from_now, Time.current, statuses[:active])
      .find_each do |resource_pack|
        # 锁的键名可以使用资源包 ID 来唯一标识
        lock_key = "resource_pack:#{resource_pack.id}:lock"
        if redis.set(lock_key, true, nx: true, ex: EXPIRE_TIME.to_i)
          # 如果锁不存在，则成功设置锁并添加任务到 Sidekiq
          ExpireResourcePackJob.set(wait_until: resource_pack.valid_to).perform_later(resource_pack.id)
        end
      end
  end

  private
  # 在更新前检查 amount 并设置 status
  def handle_empty_status
    if amount.zero?
      self.status = :empty
      remove_scheduled_job
    end
  end

  # 如果在没有过期前使用完，删除sidekiq任务
  def remove_scheduled_job
    # 获取 Sidekiq 的计划任务队列
    scheduled_jobs = Sidekiq::ScheduledSet.new
    redis = Redis.new
    # 查找并删除该 resource_pack_id 对应的任务
    scheduled_jobs.each do |job|
      item = job.item["args"]
      if job.args.first['job_class'] == 'ExpireResourcePackJob' && job.item["args"].first["arguments"].first == id
        job.delete
        # 删除 Redis 锁
        lock_key = "resource_pack:#{id}:lock"
        redis.del(lock_key)
      end
    end
  end


end
