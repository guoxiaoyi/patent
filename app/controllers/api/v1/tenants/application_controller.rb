module Api
  module V1
    class Tenants::ApplicationController < ActionController::API
      include ResponseConcern

      before_action :authenticate_tenant!

      private
      def authenticate_tenant!
        token = request.headers['Authorization']&.split(' ')&.last
        return render json: { error: 'Token missing' }, status: :unauthorized if token.blank?
        begin
          payload = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256').first
          if payload['scp'] != 'tenant'
            raise JWT::DecodeError, 'Invalid token'
          end
          @current_tenant = Tenant.find(payload['sub'])
        rescue JWT::DecodeError => e
          render json: { error: 'Invalid token' }, status: :unauthorized
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Tenant manager not found' }, status: :unauthorized
        end
      end
    end    
  end
end
