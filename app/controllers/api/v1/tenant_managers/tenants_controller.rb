class Api::V1::TenantManagers::TenantsController < Api::V1::TenantManagers::ApplicationController
  before_action :find_tenant, only: [:show, :update, :destroy, :users]

  respond_to :json

  def index
    @tenants = Tenant.all.page(params[:page]).per(params[:per_page] || 10)
    tenants_with_user_count = @tenants.map do |tenant|
      user_count = tenant.users.count
      total_tokens = tenant.users.inject(0) do |sum, user|
        sum + Message.where(user_id: user.id).sum(:input_tokens) +
        Message.where(user_id: user.id).sum(:output_tokens)
      end
      tenant.attributes.merge("user_count" => user_count, "total_tokens" => total_tokens)
    end

    render_json(message: nil, data: { 
      content: tenants_with_user_count,
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

  def users
    grouped_users = @tenant.users.group_by { |u| u.created_at.to_date }
  
    grouped_users.each do |date, users|
      grouped_users[date] = users.map do |u|
        user_conversations = u.conversations
        conversations = user_conversations.map do |conversation|
          input_tokens = Message.where(conversation_id: conversation.id, user_id: u.id).sum(:input_tokens)
          output_tokens = Message.where(conversation_id: conversation.id, user_id: u.id).sum(:output_tokens)
          
          {
            id: conversation.id,
            title: conversation.title,
            input_tokens: input_tokens,
            output_tokens: output_tokens
          }
        end
  
        u.attributes.merge("conversations" => conversations)
      end
    end
    
    render_json(message: nil, data: grouped_users.sort_by { |date, _| date }.reverse.to_h)
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
