module Api
  module V1
    class Users::FeaturesController < ApplicationController
      before_action :authenticate_user!, except: [:notify]
      before_action :set_feature, only: [:show]
      def show
        render_json(data: { cost: @feature.cost, name: @feature.name })
      end

      private

      def set_feature
        @feature = Feature.find_by(params[:feature_key])
      end
      def customer_params
        params.require(:feature).permit(:feature_key)
      end

    end
  end
end
