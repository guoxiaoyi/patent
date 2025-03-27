json.code 0
json.data do 
  json.status @status
  json.title @conversation.title
  json.metadata @conversation.metadata
  json.steps @conversation.steps do |step|
    json.id step.id
    json.key step.sub_feature.feature_key
    json.label step.sub_feature.name
    json.status step.status
  end
  json.content @messages.as_json(only: [:content, :feature_key, :sub_feature_key])
end
