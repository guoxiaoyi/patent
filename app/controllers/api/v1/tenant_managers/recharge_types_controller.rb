class Api::V1::TenantManagers::RechargeTypesController < Api::V1::TenantManagers::ApplicationController
  def index
    @recharge_types = RechargeType.with_deleted.all.page(params[:page]).per(params[:per_page] || 10)
    render_json(message: nil, data: { 
      content: @recharge_types,
      pagination: pagination_meta(@recharge_types)
    })
  end

  def create
    @recharge_type = RechargeType.new(recharge_type_params)
    
    if @recharge_type.save
      render_json(data: @recharge_type, status: :created)
    else
      render_json( message: @recharge_type.errors.full_messages.join(','), status: :unprocessable_entity, code: 1)
    end
  end
  def destroy
    find_recharge_type

    if @recharge_type.deleted?
      @recharge_type.recover
    else
      @recharge_type.destroy
    end
  
    render_json(status: :ok)
  end

  private

  def find_recharge_type
    @recharge_type = RechargeType.with_deleted.find(params[:id])
  end
  def recharge_type_params
    params.require(:recharge_type).permit(:name, :price, :discount, :amount, rules: [] )
  end
end
