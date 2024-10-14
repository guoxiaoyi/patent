module Api
  module V1
    class Users::ResourcePackTypesController < ApplicationController
      before_action :authenticate_user!
      def index
        @resource_pack_types = ResourcePackType.all
        render_json(data: @resource_pack_types)
      end
    end
  end
end
