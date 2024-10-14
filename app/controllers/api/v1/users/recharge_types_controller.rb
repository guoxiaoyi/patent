module Api
  module V1
    class Users::RechargeTypesController < ApplicationController
      before_action :authenticate_user!
      def index
        @recharge_types = RechargeType.all
        render_json(data: @recharge_types)
      end
    end
  end
end
