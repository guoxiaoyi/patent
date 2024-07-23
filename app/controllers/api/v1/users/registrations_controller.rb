module Api
  module V1
    class Users::RegistrationsController < Devise::RegistrationsController
      respond_to :json
      
      before_action :set_tenant
      def create
        verification_code = VerificationCode.find_by(phone: sign_up_params[:phone], code: params[:user][:verification_code])
        if verification_code.nil?
          render json: { errors: ['Invalid verification code'] }, status: :unprocessable_entity
        else
          build_resource(sign_up_params)
          resource.save
          if resource.persisted?
            verification_code.destroy
            render json: { message: 'Signed up successfully.' }, status: :ok
          else
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    
      private
    
      def sign_up_params
        params.require(:user).permit(:phone, :password, :password_confirmation)
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
