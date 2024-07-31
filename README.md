User 用户表
Tenant 租户表
用户登录时 通过domain 或 subdomain判断需要登录到哪个租户下

ResourcePackType 资源包类型表
RechargeType     充值包表

Transaction      用户交易记录
ResourcePack     用户资源包
Promotion        优惠表(当前没有使用)

Feature          功能表（发掘创新点等， 用来设置每使用一次收多少星币）

充值：
  User 与 Tenant 的充值逻辑一致， 在model/rechargeable.rb 中封装了充值逻辑。
  买资源包:
    首先创建 ResourcePackType，在去购买。
    当用户/租户购买时，同时在 ResourcePack, Transaction 创建了记录
    Transaction 用来记录了购买日期，谁买的， 花了多少钱， 购买了什么资源包
    ResourcePack 用来记录了资源包的过期日期，剩余余额

扣费：
  User 与 Tenant 的扣费逻辑一致， 在model/deductible.rb 中封装了扣费逻辑。
  先看租户的付费模式，如果是共享的， 扣Tenant， 如果是独享的， 扣User优先使用资源包，如果资源包不够， 扣余额。
  user.use_feature(功能表中的某个实例)
  创建一个 Transaction 使用记录，并对ResourcePack amount 或 Tenant/User上的balance 做相应的修改



### TODO

* [ ] 用户购买资源包
    * [ ] 定时任务资源包过期
    * [ ] 将要过期通知 ?
* [ ] 赠送额度（星币或资源包）租户送用户， 管理员给租户或用户 
    * [ ] 活动促销
* [ ] 交易记录
    * [ ] 扣除租户额度时需要记录是哪个用户使用的，目前只知道用了
    * [ ] 退星币(请求接口失败时，已经扣了星币需要退回)
* [ ] 对话消耗token量