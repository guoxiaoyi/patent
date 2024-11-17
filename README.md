## SaaS 平台多租户扣费系统实现
#### 功能概述
1. 多租户管理：通过 acts_as_tenant 实现了多租户管理，每个租户可以通过域名进行区分。
  >* tenant 表  subdomain 和 domain 两个字段，用于区分租户。二选一
2. 收费模式：
  >* 共享租户余额：所有用户共享租户的余额。
  >* 用户资源包：用户可以购买资源包，资源包有有效期，过期未用完则失效。
  >* 用户充值：用户可以直接充值到个人账户。
3.	资源包和充值管理：
  >* 资源包：用户或租户可以购买资源包，资源包有有效期和金额。
  >* 充值：用户或租户可以进行充值，充值金额直接增加到余额中。
4.	扣费逻辑：
  >* 优先使用资源包余额，按过期时间排序。
  >* 资源包余额不足时，从账户余额中扣除剩余部分。
  >* 扣费时会检查余额是否足够，余额不足时返回错误。
5.	优惠活动：
  >* 管理员可以赠送星币或资源包给用户或租户。
  >* 赠送的星币直接增加到余额中，赠送的资源包直接增加到资源包列表中。


## 业务流程
1. manage 创建租户，手机号，密码，域名或子域名（子域名不为空时，域名必填）
  >>* 先判断子域名，如果子域名是www则用域名查找租户，否则用子域名登录  
2. 设置功能模块(features表)
3. 够买资源包(resource_pack_types)
  >>* 当用户/租户购买时，同时在 ResourcePack, Transaction 创建了记录  
  >>* Transaction 用来记录了购买日期，谁买的， 花了多少钱， 购买了什么资源包  
  >>* ResourcePack 用来记录了资源包的过期日期，剩余余额
4. 充值
  >>* 直接在Transaction创建一条充值记录
5. 扣费
  >>* 先看租户的付费模式，如果是共享的， 扣Tenant， 如果是独享的， 扣User优先使用资源包，如果资源包不够， 扣余额。  
  user.use_feature(功能表中的某个实例)  
  创建一个 Transaction 使用记录，并对ResourcePack amount 或 Tenant/User上的balance 做相应的修改  

>> *User 与 Tenant 的扣费充值逻辑是一致的，具体看rechargeable.rb（充值）deductible.rb（扣费）*

#### 数据库
|表名|备注|
|---|----|
|ResourcePackType |资源包类型表|
|RechargeType     |充值包表|
|Transaction      |用户交易记录|
|ResourcePack     |用户资源包|
|Promotion        |优惠表(当前没有使用)|
|Feature          |功能表（发掘创新点等， 用来设置每使用一次收多少星币）|
|Projects         |项目表|

## 模型说明
### Tenant
为了确保 `Tenant` 模型中的 `domain` 和 `subdomain` 字段符合特定的业务需求，定义了以下验证规则：

#### 1. `domain` 的唯一性验证
- **代码**：`validates :domain, uniqueness: { scope: :subdomain, case_sensitive: false }, presence: true, if: :subdomain?`
- **描述**：当 `subdomain` 存在时，`domain` 字段必须在该 `subdomain` 范围内唯一，并且区分大小写。同时 `domain` 字段在 `subdomain` 存在的情况下为必填项。
- **详细说明**：
  - `uniqueness: { scope: :subdomain, case_sensitive: false }`：确保 `domain` 在相同 `subdomain` 内唯一，不区分大小写。
  - `presence: true, if: :subdomain?`：确保只有在 `subdomain` 存在时，`domain` 才是必填项。

#### 2. `subdomain` 的条件性必填验证
- **代码**：`validates :subdomain, presence: true, if: :tenant?`
- **描述**：当 `Tenant` 模型的 `mode` 字段为 `tenant` 时，`subdomain` 字段为必填项。这个条件是通过 `if: :tenant?` 方法检查的。
- **详细说明**：
  - `presence: true`：使 `subdomain` 字段在 `tenant` 模式下变为必填。
  - `if: :tenant?`：这是一个条件性验证，表示只有当 `tenant?` 方法返回 `true` 时（即当前对象处于租户模式），`subdomain` 才需要存在。

#### 3. `subdomain` 和 `domain` 的组合验证
- **代码**：`validate :subdomain_or_domain_present`
- **描述**：该自定义验证方法确保在 `subdomain` 和 `domain` 中至少有一个字段存在，否则验证失败。
- **详细说明**：
  - 自定义方法 `subdomain_or_domain_present` 检查两个字段都为空的情况。如果 `subdomain` 和 `domain` 均为空，则添加错误信息：`Either subdomain or domain must be present`，确保至少填写一个。
  - 这个验证作为额外保护，防止出现两个字段均为空的无效状态。

#### 验证逻辑总结
上述验证逻辑确保了 `Tenant` 模型中 `domain` 和 `subdomain` 字段之间的关系符合业务规则：
- `domain` 在 `subdomain` 范围内必须唯一。
- 当模式为 `tenant` 时，`subdomain` 是必填字段。
- 如果 `subdomain` 存在，则 `domain` 也是必填字段。
- 这两个字段中至少有一个需要填写，以保证记录的有效性。

### ResourcePackType
#### 表字段说明

| 字段名       | 数据类型 | 说明                     |
|--------------|----------|--------------------------|
| `id`         | integer  | 主键，自增               |
| `name`       | string   | 资源包的名称             |
| `price`      | decimal  | 资源包的价格             |
| `discount`   | decimal  | 资源包的折扣             |
| `amount`     | integer  | 资源包包含星币的数量      |
| `valid_days` | integer  | 资源包的有效天数         |

- **amount**：资源包包含星币的数量，够买资源包后会转换成星币的数量，如10元的资源包中 包含100个星币，类似与流量包的概念





## TODO
* [ ] 租户设置表
    * [ ] 备案信息

* [ ] 用户购买资源包
    * [ ] 充值活动
      * [ ] 新用户首次充值 送优惠 0.01 N币 注册15天内
      * [ ] 长时间未使用用户激活，充值优惠
    * [X] 定时任务资源包过期
    * [ ] 将要过期通知 ?
    * [ ] 通过weksocket 下单，回调成功时，通知前端
    * [ ] 服务器安装redis, sidekiq
* [ ] 赠送额度（星币或资源包）租户送用户， 管理员给租户或用户 
    * [ ] 活动促销
* [ ] 交易记录
    * [ ] 扣除租户额度时需要记录是哪个用户使用的，目前只知道用了
    * [ ] 退星币(请求接口失败时，已经扣了星币需要退回)
* [ ] 对话消耗token量

#### 加急
* [ ] 百度统计
* [ ] sitemap 站长统计
* [ ] SEO
* [ ] 帮助文档
* [X] 备案号
* [X] 发掘创新点
* [ ] 撰写申请书
 * [ ] 充值活动
    * [ ] 新用户首次充值 送优惠 0.01 N币 注册15天内
* [ ] 发短信验证码
* [ ] 论坛注册账号
* [ ] 微信
* [ ] 电话

-----------------------
* [X] 创建conversation时，同步创建steps, 即feature中的sub_features
* [X] 然后fueature.use(conversation)时， 根据不同的feature_key， 调用不同的方法
* [X] 挖掘创新点
* [X] 撰写申请书实现到按sub_features中的排序，放到sidekiq中
  >* [X] 对接ai, 像前端推送
  >* [X] 任务完成钩子（决定之后将哪个任务添加到sidekiq）
  >* [X] message 中feature_key 字段 用来区分不同的任务， 但feature 与 sub_feature中的 feature_key 冲突， 需要处理下
* [X] conversation 增加了 project字段，前端需要将project id 传过来
* ~~[ ] 修改撰写申请书~~
* [ ] 申请书生成文档
* [ ] 交易记录关联conversation表
