module Pay
  class Wechat
    # 定义常量
    APP_ID = "wxf1de735a892cff18"
    MCH_ID = "1693244984"
    PRIVATE_KEY = File.read("#{Rails.root}/config/wechat/apiclient_key.pem")
    CERTIFICATE = OpenSSL::X509::Certificate.new(File.read("#{Rails.root}/config/wechat/wechatpay_62A67C184C15F246562B570733E6D56E41DF6A9F.pem"))
    SERIAL_NO = "298F7968B523E44B9A3E37B24B9D08E1EA19F188"
    WECHATPAY_SERIAL = "62A67C184C15F246562B570733E6D56E41DF6A9F"
    API_V3_KEY = "d8HrX3CgqbtA8HrX38CqbX3CgqbtA8Hr"


    def initialize(params)
      @body = params[:body].merge({
        appid: APP_ID,
        mchid: MCH_ID,
        notify_url: params[:notify_url]
      })
      @url = params[:url]
      @method = params[:method]
      @random = SecureRandom.hex(16).to_s
      @timestamp = Time.now.to_i
    end

    def native
      headers = build_headers
      response = HTTParty.post("https://api.mch.weixin.qq.com#{@url}", body: @body.to_json, headers: headers)
      parse_response(response)
    end

    # 验证微信回调请求签名
    def self.verify_signature(headers:, body:)
      timestamp = headers['HTTP_WECHATPAY_TIMESTAMP']
      nonce = headers['HTTP_WECHATPAY_NONCE']
      signature = headers['HTTP_WECHATPAY_SIGNATURE']
      serial = headers['HTTP_WECHATPAY_SERIAL']
      
      unless serial == CERTIFICATE.serial.to_s(16).upcase
        Rails.logger.info "证书序列号不匹配: 期望 #{CERTIFICATE.serial.to_s(16).upcase}, 实际 #{serial}"
        return false
      end
      # 拼接签名字符串
      data = "#{timestamp}\n#{nonce}\n#{body}\n"
      # 验证签名
      decoded_signature = Base64.decode64(signature)
      
      is_verified = CERTIFICATE.public_key.verify(
        OpenSSL::Digest::SHA256.new,
        decoded_signature,
        data
      )

      unless is_verified
        raise "签名验证失败"
      end

      true
      rescue => e
        Rails.logger.info "签名验证失败: #{e.message}"
        false
    end

    # 解密微信支付回调通知中的加密数据
    def self.decrypt_notification(nonce:, associated_data:, ciphertext:)
      cipher = OpenSSL::Cipher.new('aes-256-gcm')
      cipher.decrypt
      cipher.key = API_V3_KEY
      cipher.iv = nonce
      cipher.auth_data = associated_data

      # 解密内容和 GCM 的认证 tag (最后16字节)
      decoded_data = Base64.decode64(ciphertext)
      encrypted_data = decoded_data[0...-16]
      tag = decoded_data[-16..]

      # 设置认证标签
      cipher.auth_tag = tag

      # 执行解密操作
      decrypted_data = cipher.update(encrypted_data) + cipher.final
      JSON.parse(decrypted_data)
    rescue => e
      Rails.logger.info "解密失败: #{e.message}"
      nil
    end
    

    private

    def build_headers
      {
        "Authorization" => generate_authorization,
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "Wechatpay-Serial" => SERIAL_NO  # 证书序列号
      }
    end

    def generate_authorization
      # 使用私钥生成签名 (此处简化了签名过程，需要按文档细化)
      _params = {
        mchid: MCH_ID,            # 商户号
        nonce_str: @random,       # 随机字符串
        serial_no: SERIAL_NO,     # 证书序列号
        signature: sign,          # 签名
        timestamp: @timestamp     # 时间戳
      }.map { |key, value| "#{key}=\"#{value}\"" }.join(',')
      "WECHATPAY2-SHA256-RSA2048 #{_params}"
    end

    def sign
      rsa_private = OpenSSL::PKey::RSA.new(PRIVATE_KEY)
      data = "#{@method}\n#{@url}\n#{@timestamp}\n#{@random}\n#{@body.to_json}\n"
      signature = rsa_private.sign(OpenSSL::Digest::SHA256.new, data)
      Base64.strict_encode64(signature)
    end

    def parse_response(response)
      JSON.parse(response.body)
    end
  end
end
