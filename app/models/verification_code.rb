class VerificationCode < ApplicationRecord
  before_create :generate_code

  def generate_code
    self.code = Rails.env.development? ? '123456' : rand(100_000..999_999).to_s
  end

  def send_sms
    endpoint = "https://dysmsapi.aliyuncs.com"
    access_key_id = ENV['ALIYUN_ACCESS_KEY_ID']
    access_key_secret = ENV['ALIYUN_ACCESS_KEY_SECRET']
    region_id = "cn-hangzhou" # Modify according to your region
    action = "SendSms"

    params = {
      Action: action,
      PhoneNumbers: self.phone,
      SignName: 'PatStars派斯达',
      TemplateCode: 'SMS_304992984',
      TemplateParam: { code: self.code }.to_json,
      RegionId: region_id,
      Format: "JSON",
      Version: "2017-05-25",
      Timestamp: Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
      SignatureMethod: "HMAC-SHA1",
      SignatureVersion: "1.0",
      SignatureNonce: SecureRandom.uuid,
      AccessKeyId: access_key_id
    }
    # Generate the signature
    signature = generate_signature(params, access_key_secret)

    # Add the signature to the params
    params[:Signature] = signature

    # Send the request
    response = HTTParty.post(endpoint, query: params)
    response.parsed_response
  end

  private

  # 阿里云规范化签名方法
  def generate_signature(params, access_key_secret)
    # Step 1: 对参数排序并格式化为 key=value
    canonicalized_query_string = params.sort.map { |key, value| "#{percent_encode(key)}=#{percent_encode(value)}" }.join("&")

    # Step 2: 构造待签名字符串
    string_to_sign = "POST&%2F&#{percent_encode(canonicalized_query_string)}"

    # Step 3: 使用 HMAC-SHA1 生成签名
    key = "#{access_key_secret}&"
    digest = OpenSSL::HMAC.digest('sha1', key, string_to_sign)
    Base64.strict_encode64(digest)
  end
  # 阿里云要求的 URL 编码方法
  def percent_encode(value)
    ERB::Util.url_encode(value.to_s)
      .gsub('+', '%20')
      .gsub('*', '%2A')
      .gsub('%7E', '~')
  end
end