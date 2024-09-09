class Api::V1::TenantManagers::TransactionsController < Api::V1::TenantManagers::ApplicationController
  respond_to :json

  def index
    @transactions = Transaction.all.page(params[:page]).per(params[:per_page] || 10)
    render_json(message: nil, data: { 
      content: @transactions,
      pagination: pagination_meta(@transactions)
    })
  end
end
