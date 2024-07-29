module Api
  module V1
    class TenantManagers::DashboardController < Api::V1::TenantManagers::ApplicationController
      before_action :authenticate_tenant_manager!

      def index
        render json: { message: 'Welcome to TenantManager Dashboard', tenant_manager: @current_tenant_manager }
      end

      def tenants
        @tenants = Tenant.all
        render json: @tenants
      end

      def users
        @users = User.all
        render json: @users
      end
    end
  end
end
