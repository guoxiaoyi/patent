module Api
  module V1
    class Users::TransactionsController < ApplicationController
      before_action :authenticate_user!
      def index
        # 获取前端传递的参数，例如 'billings' 或 'deductions'
        transaction_scope = params[:transaction_scope]
        valid_scopes = %w[billings deductions]

        # 检查 transaction_scope 是否是 Transaction 模型的一个有效 scope
        if valid_scopes.include?(transaction_scope)
          @transactions = @current_user.transactions.send(transaction_scope)
        else
          @transactions = @current_user.transactions.none # 默认返回所有记录
        end

        # 添加分页和每页数量
        @transactions = @transactions.page(params[:page]).per(params[:per_page] || 10)
        render :index, formats: :json
      end
    end
  end
end
