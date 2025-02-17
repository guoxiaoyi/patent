module Api
  module V1
    class TenantManagers::DashboardController < Api::V1::TenantManagers::ApplicationController
      before_action :authenticate_tenant_manager!

      def index
        sort_by = params[:sort_by]
        valid_sort_keys = ['conversations_count', 'input_tokens', 'output_tokens', 'total_tokens']
        # Defaults to sorting by conversations_count if sort_by param is missing or invalid
        sort_key = valid_sort_keys.include?(sort_by) ? sort_by : 'conversations_count'
        
        users_data = User.all.map do |user|
          conversation_ids = user.conversations.pluck(:id)
          input_sum  = Message.where(:conversation_id.in => conversation_ids).sum(:input_tokens)
          output_sum = Message.where(:conversation_id.in => conversation_ids).sum(:output_tokens)

          {
            phone: user.phone,
            conversations_count: user.conversations.count,
            input_tokens: input_sum,
            output_tokens: output_sum,
            total_tokens: input_sum + output_sum,
            created_at: user.created_at
          }
        end.sort_by { |u| -u[sort_key.to_sym] }

        render_json(data: users_data)
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
