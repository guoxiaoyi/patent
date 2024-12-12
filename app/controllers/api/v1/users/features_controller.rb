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
        @feature = Feature.find_by(feature_key: params[:id])
      end
    end
  end
end
