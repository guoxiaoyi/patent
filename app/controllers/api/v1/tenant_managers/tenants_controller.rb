class Api::V1::TenantManagers::TenantsController < Api::V1::TenantManagers::ApplicationController
  before_action :find_tenant, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @tenants = Tenant.all
    render_json(message: nil, data: @tenants)
  end

  def show
    respond_with(@tenant)
  end

  def create
    @tenant = Tenant.new(tenant_params)
    
    if @tenant.save
      render json: @tenant, status: :created
    else
      render json: { errors: @tenant.errors }, status: :unprocessable_entity
    end
  end

  def update
    flash[:notice] = 'Api::V1::TenantManagers::Tenant was successfully updated.' if @tenant.update(tenant_params)
    respond_with(@tenant)
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
      params.require(:tenant).permit(:email, :password, :password_confirmation, :domain, :subdomain, :name)
    end
end
