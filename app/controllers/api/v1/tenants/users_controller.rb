module Api
  module V1
    
      class Tenants::UsersController < Api::V1::Tenants::ApplicationController
        def index
          @users = @current_tenant.users.all
          render_json(message: nil, data: @users)
        end
      end
    
  end
end
