module Api
  module V1
    class TenantManagers::VerificationCodesController < ActionController::API
      def create
        verification_code = VerificationCode.find_or_initialize_by(phone: params[:phone])
        verification_code.save
        verification_code.send_sms
        # 在此处调用Twilio或其他服务发送验证码
        render_json(message: 'Verification code sent successfully.', data: nil)
      end
    end
  end
end
