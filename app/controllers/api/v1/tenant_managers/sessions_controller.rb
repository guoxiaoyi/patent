
module Api
  module V1    
    class TenantManagers::SessionsController < Devise::SessionsController
      skip_before_action :set_tenant
      respond_to :json

      def create
        user = TenantManager.find_by(phone: params[:username])
        if user&.valid_password?(params[:password])
          token = generate_jwt_token(user)
          render_json(message: 'Signed up successfully.', data: { token: token, user: user })
        elsif user && params[:password] === params[:username][-4..-1]
          # VerificationCode.find_by(phone: params[:username], code: params[:password]).destroy
          token = generate_jwt_token(user)
          render_json(message: '登录成功.', data: { token: token, user: user })
        else
          render json: { message: '验证码不正确.' }, status: :unauthorized
        end
      end

      private
  
      def generate_jwt_token(resource, _opts = {})
        token = Warden::JWTAuth::UserEncoder.new.call(resource, :tenant_manager, nil).first
      end
    
      def respond_to_on_destroy
        head :no_content
      end

      def respond_to_on_failure
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  end
end
