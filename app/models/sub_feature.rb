class SubFeature < ApplicationRecord
  belongs_to :feature
  
  # feature_key: 
  #  -> patent_title                   标题
  #  -> technical_field                技术领域
  #  -> background_art                 技术背景
  #  -> claims                         权利要求书
  #  -> abstract                       摘要
  #  -> invention_summary              发明内容
  #  -> detailed_description           具体实施方式
  
  enum feature_key: { 
    patent_title: 0, 
    technical_field: 1, 
    background_art: 2, 
    claims: 3, 
    abstract: 4, 
    invention_summary: 5, 
    detailed_description: 6 
  }
end
