module Api
  module V1
    class Users::VerificationCodesController < ActionController::API
      include ResponseConcern
      def create
        verification_code = VerificationCode.find_or_initialize_by(phone: params[:phone])
        verification_code.save
        # 在此处调用Twilio或其他服务发送验证码
        render_json(message: '发送成功', data: verification_code.code )
      end
    end
  end
end
