require "test_helper"

class Api::V1::TenantManagers::TenantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_v1_tenant_managers_tenant = api_v1_tenant_managers_tenants(:one)
  end

  test "should get index" do
    get api_v1_tenant_managers_tenants_url, as: :json
    assert_response :success
  end

  test "should create api_v1_tenant_managers_tenant" do
    assert_difference("Api::V1::TenantManagers::Tenant.count") do
      post api_v1_tenant_managers_tenants_url, params: { api_v1_tenant_managers_tenant: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show api_v1_tenant_managers_tenant" do
    get api_v1_tenant_managers_tenant_url(@api_v1_tenant_managers_tenant), as: :json
    assert_response :success
  end

  test "should update api_v1_tenant_managers_tenant" do
    patch api_v1_tenant_managers_tenant_url(@api_v1_tenant_managers_tenant), params: { api_v1_tenant_managers_tenant: {  } }, as: :json
    assert_response :success
  end

  test "should destroy api_v1_tenant_managers_tenant" do
    assert_difference("Api::V1::TenantManagers::Tenant.count", -1) do
      delete api_v1_tenant_managers_tenant_url(@api_v1_tenant_managers_tenant), as: :json
    end

    assert_response :no_content
  end
end
