class Api::V1::TenantManagers::TenantsController < Api::V1::TenantManagers::ApplicationController
  before_action :find_tenant, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @tenants = Tenant.all.page(params[:page]).per(params[:per_page] || 10)
    render_json(message: nil, data: { 
      content: @tenants,
      pagination: pagination_meta(@tenants)
    })
  end

  def show
    respond_with(@tenant)
  end

  def create
    @tenant = Tenant.new(tenant_params)
    
    if @tenant.save
      render_json(data: @tenant, status: :created)
    else
      render_json( message: @tenant.errors.full_messages.join(','), status: :unprocessable_entity, code: 1)
    end
  end

  def update
    if @tenant.update(tenant_params)
      render_json(data: @tenant)
    else
      render_json(message: @tenant.errors.full_messages.join(','), status: :unprocessable_entity, code: 1)
    end
  end

  def destroy
    @tenant.destroy
    respond_with(@tenant)
  end

  private
    def find_tenant
      @tenant = Tenant.find(params[:id])
    end

    def tenant_params
      params.require(:tenant).permit(:phone, :domain, :subdomain, :name, :mode, :billing_mode)
    end
end
