json.message 'success'
json.code 0

json.data do
  json.content @projects do |project|
    json.id project.id
    json.customer project.customer.as_json(only: [:id, :name])
    json.name project.name
    json.created_at project.created_at.strftime('%Y-%m-%d %H:%M:%S')
    json.updated_at project.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    # 根据需要添加更多字段
  end

  # 添加分页信息
  json.pagination do
    json.current_page @projects.current_page
    json.per_page @projects.limit_value
    json.total_pages @projects.total_pages
    json.total_count @projects.total_count
  end
end
