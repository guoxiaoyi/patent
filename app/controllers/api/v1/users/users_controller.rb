

module Api
  module V1
    class Users::UsersCodesController < ApplicationController
      def recharge
        # 处理用户充值逻辑
      end
      
      def purchase_resource_pack
        resource_pack_type = ResourcePackType.find(params[:resource_pack_type_id])
        current_user.purchase_resource_pack(resource_pack_type)
        redirect_to user_path(current_user)
      end
      
      def use_feature
        feature = Feature.find(params[:feature_id])
        if current_user.use_feature(feature)
          redirect_to user_path(current_user), notice: "Feature used successfully."
        else
          redirect_to user_path(current_user), alert: current_user.errors.full_messages.join(", ")
        end
      end
    end
  end
end
