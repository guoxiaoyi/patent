class ApplicationController < ActionController::API
  before_action :refresh_jwt_token
  # set_current_tenant_by_subdomain_or_domain
  include ResponseConcern
  protected
  def authenticate_user!
    # if request.headers['Authorization'].present?
    #   begin
    #     jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.secret_key_base!).first
    #     @current_user = User.find(jwt_payload['sub'])
    #     @current_store = Store.find(jwt_payload['aud']['store_id'])
    #     requested_store = store_from_domain
    #     if requested_store.nil? || @current_store.id != requested_store.id
    #       head :unauthorized
    #     end
    #   rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
    #     head :unauthorized
    #   end
    # else
    #   head :unauthorized
    # end
  end

  def current_user
    @current_user
  end
  def current_store
    @current_store
  end

  private
  def refresh_jwt_token
    if current_user
      token = Warden::JWTAuth::UserEncoder.new.call(current_user, :user, nil).first
      response.set_header('Authorization', "Bearer #{token}")
    end
  end

  def set_current_tenant_by_subdomain_or_domain
    subdomain = request.subdomain
    domain = request.domain
    if subdomain.present? && subdomain != 'www'
      set_current_tenant(Tenant.find_by(subdomain: subdomain))
    elsif domain.present?
      set_current_tenant(Tenant.find_by(domain: domain))
    else
      set_current_tenant(Tenant.find_by(domain: request.host))
    end
  end

  def set_current_tenant(tenant)
    p tenant
    if tenant
      ActsAsTenant.current_tenant = tenant
    else
      render json: { error: 'Tenant not found' }, status: :not_found
    end
  end
end
