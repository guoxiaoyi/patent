json.message 'success'
json.code 0

json.data do
  json.code @payment.code
  json.status @payment.status
  json.code_url @wechat_pay_response['code_url']
end
