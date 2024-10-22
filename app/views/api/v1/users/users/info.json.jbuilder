json.message 'success'
json.code 0

json.data do
  json.balance @current_user.balance
  json.phone @current_user.phone
  json.resource_packs do
    json.amount @current_user.resource_packs.available.sum(:amount)
    json.valid_to @current_user.resource_packs.available.first&.valid_to&.strftime('%Y-%m-%d %H:%M:%S')
    json.valid_days @current_user.resource_packs.available.first&.remaining_days
  end
end
