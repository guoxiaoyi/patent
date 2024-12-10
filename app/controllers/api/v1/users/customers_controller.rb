module Api
  module V1
    class Users::CustomersController < ApplicationController
      before_action :authenticate_user!, except: [:notify]
      def index
        @customers = @current_user.customers
        render_json(data: @customers)
      end

      def create
        @customer = @current_user.customers.build(customer_params.merge(tenant: current_tenant))
        if @customer.save
          render_json(data: @customer)
        else
          render_json(message: '缺少参数', status: :unprocessable_entity, code: 1)
        end
      end

      private

      def customer_params
        params.require(:customer).permit(:name)
      end

    end
  end
end
