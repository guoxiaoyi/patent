module Api
  module V1
    class TenantManagers::ApplicationController < ActionController::API
      include ResponseConcern

      before_action :authenticate_tenant_manager!

      private
      def authenticate_tenant_manager!
        token = request.headers['Authorization']&.split(' ')&.last
        return render json: { error: 'Token missing' }, status: :unauthorized if token.blank?
        begin
          payload = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256').first
          if payload['scp'] != 'tenant_manager'
            raise JWT::DecodeError, 'Invalid token'
          end
          @current_tenant_manager = TenantManager.find(payload['sub'])
        rescue JWT::DecodeError => e
          render json: { error: 'Invalid token' }, status: :unauthorized
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Tenant manager not found' }, status: :unauthorized
        end
      end

      def pagination_meta(object)
        {
          current_page: object.current_page,
          next_page: object.next_page,
          prev_page: object.prev_page,
          total_pages: object.total_pages,
          total_count: object.total_count
        }
      end
    end
  end
end
