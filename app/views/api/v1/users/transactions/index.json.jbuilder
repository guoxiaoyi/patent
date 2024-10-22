#  {
#   "id":1,
#   "account_type":"User",
#   "account_id":1,
#   "amount":100,
#   "transaction_type":"recharge",
#   "transactionable_type":"RechargeType",
#   "transactionable_id":1,
#   "description":"充值 100 星币",
#   "created_at":"2024-10-15T13:52:12.081+08:00",
#   "updated_at":"2024-10-15T13:52:12.081+08:00"
# }
json.message 'success'
json.code 0

json.data do
  json.content @transactions do |transaction|
    json.kind I18n.t("activerecord.attributes.transaction.transaction_type.#{transaction.transaction_type}")
    json.description transaction.description
    if transaction.payment.present?
      json.payment transaction.payment.as_json(only: [:amount])
    end
    # 购买
    if  Transaction::BILLING_TYPES.include?(transaction.transaction_type)
      if transaction.transactionable.is_a?(ResourcePack) && transaction.transactionable.valid_to.present?
        json.valid_to transaction.transactionable.valid_to.strftime('%Y-%m-%d %H:%M:%S')
        json.status do
          json.key transaction.transactionable.status
          json.text I18n.t("activerecord.attributes.resource_pack.status.#{transaction.transactionable.status}")
        end
      else
        json.status do
          json.key 'never'
          json.text I18n.t("activerecord.attributes.resource_pack.status.never")
        end
      end
    end
    
    json.created_at transaction.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end

  # 添加分页信息
  json.pagination do
    json.current_page @transactions.current_page
    json.per_page @transactions.limit_value
    json.total_pages @transactions.total_pages
    json.total_count @transactions.total_count
  end
end
