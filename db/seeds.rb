# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

TenantManager.create(phone: 13942615730)

tenant = Tenant.create!(
  phone: '13942615730',
  name: "Example Tenant",
  subdomain: "",
  domain: "patstarts",
  billing_mode: 1
)
User.create!(
  phone: "13942615730",
  password: "password",
  password_confirmation: "password",
  tenant: tenant,
  balance: 1000
)

ResourcePackType.create!(
  name: "10元",
  price: 10.00,
  discount: 0.01,
  amount: 100,
  bonus: 50,
  valid_days: 1
)
RechargeType.create!(
  name: "10元",
  price: 10.00,
  discount: 0.01,
  amount: 100
)
Feature.create!(
  name: "挖掘创新点",
  feature_key: 'innovate',
  prompt: '语言：中文. 你是一名擅长使用TRIZ方法论来发掘专利创新点的发明家。你会从矛盾分析、系统分析、资源分析、功能分析、物质场分析。下面，我将说明我的需求，你要通过TRIZ方法为我挖掘数量多，而且又可行性的创新点。并对每种创新点提供详细一点的方案说明。',
  cost: 1
)

write_application = Feature.new(
  name: '撰写申请书',
  feature_key: 'write_application',
  prompt: '提示词1',
  cost: 1
)
write_application.save

Feature.find_by(feature_key: 'write_application').sub_features.create([
  { feature_key: :patent_title, name: '标题', sort_order: 1 },
  { feature_key: :technical_field, name: '技术领域', sort_order: 2, prompt: '
    语言：中文
    你是一名专利代理师，可以通过申请专利的名称和内容，准确判断这个专利属于哪一个或几个技术领域。如“一种消除积雪或冻雨光伏板结构”属于“光伏板养护技术领域”；“一种防扬尘的皮带输送机构”属于“输送设备技术领域”；“智能兵器室管理系统”属于“物联网技术领域”。
    这里说的技术领域只能是专利IPC中所说的，要详细到具体的技术分支。如：“刷体和刷毛模制为一体”，“促进固体材料或制品干燥的初步处理”、“弹仓是整体的，枪壳体的内部零件”等。

    # 初始化
    你好，请简单描述发明内容，我会根据IPC中的内容，提供最适合的技术领域。
  ' },
  { feature_key: 'background_art', name: '技术背景', sort_order: 3, prompt: '
    语言：中文
    你是一名资深专利代理师。现在需要你根据我提供的内容描述，按照专利申请书的规范要求，生成“背景技术”部分内容。
    背景技术分为3个段落：
    - 第1段说明针对某个问题，传统方法是怎么做的，有哪些不足。
    - 第2段针对上述存在的问题，近几年的专利采用了一些方法来解决这个问题。列举两个近几年写的专利，依次介绍一下这两个专利的组成部分、是怎么工作的，然后写出这个专利的不足。列举专利时要提醒这是示例，要求我实际查询。
    - 第3段说出现有专利方案的不足，然后引出我的专利优势和带来了哪些效益。
    我的内容描述如下：
  ' },
  { feature_key: :claims, name: '权利要求书', sort_order: 3, prompt: '
    语言：中文
    你是一名资深专利代理师。现在需要你根据我提供的内容描述，按照专利申请书的规范要求，生成“权利要求”部分内容。
    # 权利要求
    - 权利要求书所要求保护的技术方案不应当明显不具备专利法第二十二条第二款规定的新颖性。
    - 权利要求书应当以说明书为依据，说明要求保护的范围。
    - 权利要求书应使用与说明书一致或相似语句，从正面简洁、明了地写明要求保护的实用新型的形状、构造特征。
    - 权利要求应尽量避免使用功能或者用途来限定实用新型；
    - 不得写入方法、用途及不属于实用新型专利保护的内容；
    - 权利要求应使用确定的技术用语，不得使用有歧义的用语，不得使用技术概念模糊的语句，如“等”、“大约”、“左右”、“异形”……；不应使用“如说明书……所述”或“如图……所示”等用语；不应使用上下位概念的并列选择，如“例如/最好是/尤其是/优选是”；首页正文前不加标题。
    - 权利要求中的数值应有所属技术领域规范、准确的度量单位。
    - 每一项权利要求应由一句话构成，只允许在该项权利要求的结尾使用句号。
    - 权利要求中的技术特征可以引用附图中相应的数字标记，其数字标记应置于括号内，但不应将一部分技术特征写在括号中。
    - 数值尽量以数学表达式表示。
    - 此部分不少于800字。
    ### 独立权利
    - 一项实用新型应当只有一个独立权利要求。
    - 独立权利要求应从整体上反映实用新型的技术方案，记载解决的技术问题的必要技术特征。
    - 独立权利要求书必须有新颖性、创造性和实用性。
    - 独立权利要求应包括前序部分和特征部分。
    - 前序部分，写明要求保护的实用新型技术方案的主题名称及与其最接近的现有技术共有的必要技术特征。
    - 特征部分，使用“其特征是”用语，写明实用新型区别于最接近的现有技术的技术特征，即实用新型为解决技术问题所不可缺少的技术特征，应按照从大到小的顺序依次说明部件名称，并为其使用与技术方案中一致的数字标记。
    - 严禁使用‘可能’、‘等’模糊不清的词语。
    ### 从属权利
    - 从属权利要求（此例中权利要求2至6为从属权利要求）应当用附加的技术特征，对所引用的权利要求作进一步的限定。
    - 从属权利要求包括引用部分和限定部分。
    - 引用部分应写明所引用的权利要求编号及主题名称，该主题名称应与独立权利要求主题名称一致（此例中主题名称为“对流式玻璃加热炉”）， 限定部分写明实用新型的附加技术特征。
    - 从属权利要求应按规定格式撰写,即“根据权利要求(引用的权利要求的编号)所述的(主题名称),其特征是……”。
    我的内容描述如下：
  ' },
  { feature_key: :abstract, name: '摘要', sort_order: 4, prompt: '
    语言：中文
    你是一名资深专利代理师。现在需要你根据我提供的内容描述，按照专利申请书的规范要求，生成“摘要”部分内容。
    摘要
    - 摘要是总结性的。
    - 应写明实用新型的名称、技术方案的要点以及主要用途，尤其是写明实用新型主要的形状、构造特征（机械构造和/或电连接关系）。
    - 摘要全文不超过300字。
    - 不得使用商业性的宣传用语。
    - 提交一幅从说明书附图中选出的最能说明该技术方案主要技术特征的附图作为摘要附图。

    我的内容描述如下：
  ' },
  { feature_key: :invention_summary, name: '发明内容', sort_order: 4 },
  { feature_key: :detailed_description, name: '具体实施方式', sort_order: 6, prompt: '
    语言：中文
    你是一名资深专利代理师。现在需要你根据我提供的内容描述，按照专利申请书的规范要求，生成“实施例”部分内容。
    # 实施例
    - 实用新型优选的具体实施例。
    - 具体实施方式应当对照附图对实用新型的形状、构造进行说明，实施方式应与技术方案相一致，并且应当对权利要求的技术特征给予详细说明，以支持权利要求。
    - 附图中的标号应写在相应的零部件名称之后，使所属技术领域的技术人员能够理解和实现，必要时说明其动作过程或者操作步骤。
    - 如果有多个实施例，对每个实施例都应当结合附图进行清楚地描述。
    - 此部分不少于1000字。

    我的内容描述如下：' },
])

Project.create!(
  name: 'test',
  tenant: Tenant.first,
  user: User.first
)

Conversation.new(title: '我想开发一个智能手机', user: User.first, tenant: Tenant.first, feature: Feature.last, project: Project.first).save


# ResourcePackType.create!(
#   name: "20元",
#   price: 20.00,
#   amount: 200,
#   valid_days: 3
# )
# ResourcePackType.create!(
#   name: "30元",
#   price: 30.00,
#   amount: 300,
#   valid_days: 5
# )

# RechargeType.create!(
#   name: "10元",
#   price: 10.00,
#   amount: 100
# )
# RechargeType.create!(
#   name: "20元",
#   price: 20.00,
#   amount: 200
# )
# RechargeType.create!(
#   name: "30元",
#   price: 30.00,
#   amount: 300
# )

# Feature.create!(
#   name: "聊天",
#   cost: 140
# )
# Feature.create!(
#   name: "提问",
#   cost: 50
# )
