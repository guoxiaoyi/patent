module Api
  module V1
    class Users::SessionsController < Devise::SessionsController
      respond_to :json
      
      before_action :set_tenant
      before_action :check_required_params, only: :create

      def create
        user = User.find_by(phone: params[:user][:phone])
        if user&.valid_password?(params[:user][:password])
          token = generate_jwt_token(user)
          render_json(message: 'Signed up successfully.', data: { token: token, user: user })
        elsif user && VerificationCode.exists?(phone: params[:user][:phone], code: params[:user][:verification_code])
          VerificationCode.find_by(phone: params[:user][:phone], code: params[:user][:verification_code]).destroy
          token = generate_jwt_token(user)
          render_json(message: 'Signed up successfully.', data: { token: token, user: user })
        else
          render json: { message: 'Invalid login credentials or verification code.' }, status: :unauthorized
        end
      end

      private

      def generate_jwt_token(user)
        Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      end
      def check_required_params
        required_params = [:phone, :verification_code] # Add all required parameters here
        missing_params = required_params.select { |param| params[:user][param].blank? }

        if missing_params.any?
          render_json(message: "缺失必要参数", data: missing_params, code: 422, status: :ok)
        end
      end

      def set_tenant
        subdomain = request.subdomain
        domain = request.domain
        if subdomain.present? && subdomain != 'www'
          set_current_tenant(Tenant.find_by(subdomain: subdomain))
        elsif domain.present?
          set_current_tenant(Tenant.find_by(domain: domain))
        else
          set_current_tenant(Tenant.find_by(domain: request.host))
        end
      end
    end
  end
end
