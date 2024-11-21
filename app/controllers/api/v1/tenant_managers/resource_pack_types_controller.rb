class Api::V1::TenantManagers::ResourcePackTypesController < Api::V1::TenantManagers::ApplicationController
  def index
    @resource_pack_types = ResourcePackType.with_deleted.all.page(params[:page]).per(params[:per_page] || 10)
    render_json(message: nil, data: { 
      content: @resource_pack_types,
      pagination: pagination_meta(@resource_pack_types)
    })
  end

  def create
    @resource_pack_type = ResourcePackType.new(resource_pack_type_params)
    
    if @resource_pack_type.save
      render_json(data: @resource_pack_type, status: :created)
    else
      render_json( message: @resource_pack_type.errors.full_messages.join(','), status: :unprocessable_entity, code: 1)
    end
  end
  def destroy
    find_resource_pack_type

    if @resource_pack_type.deleted?
      @resource_pack_type.recover
    else
      @resource_pack_type.destroy
    end
  
    render_json(status: :ok)
  end

  private

  def find_resource_pack_type
    @resource_pack_type = ResourcePackType.with_deleted.find(params[:id])
  end
  def resource_pack_type_params
    params.require(:resource_pack_type).permit(:name, :price, :bonus, :discount, :amount, :valid_days, rules: [])
  end
end
