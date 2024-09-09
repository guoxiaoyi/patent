module Api
  module V1
    class Tenants::TenantsController < Api::V1::Tenants::ApplicationController
      def recharge
        # 处理租户充值逻辑
      end
    
      def purchase_resource_pack
        resource_pack_type = ResourcePackType.find(params[:resource_pack_type_id])
        tenant = Tenant.find(params[:tenant_id])
        tenant.purchase_resource_pack(resource_pack_type)
        # redirect_to tenant_path(tenant), notice: "Resource pack purchased successfully."
        render_json(data: nil)
      end
    
      def use_feature
        feature = Feature.find(params[:feature_id])
        tenant = Tenant.find(params[:tenant_id])
        if tenant.use_feature(feature)
          # redirect_to tenant_path(tenant), notice: "Feature used successfully."
          render_json(data: nil)
        else
          # redirect_to tenant_path(tenant), alert: tenant.errors.full_messages.join(", ")
          render_json(data: nil)
        end
      end
    end
  end
end