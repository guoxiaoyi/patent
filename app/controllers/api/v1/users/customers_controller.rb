module Api
  module V1
    class Users::CustomersController < ApplicationController
      def index
        @customers = current_tenant.customers
        render_json(data: @customers)
      end

      def create
        @customer = current_tenant.customers.build(customer_params)
          if @customer.save
            render_json(data: @customer)
          else
            render_json(data: @customer.errors, status: :unprocessable_entity)
          end
      end

      private

      def customer_params
        params.require(:customer).permit(:name)
      end

    end
  end
end
