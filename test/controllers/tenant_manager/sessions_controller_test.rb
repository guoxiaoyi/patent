require "test_helper"

class TenantManager::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get tenant_manager_sessions_create_url
    assert_response :success
  end

  test "should get destroy" do
    get tenant_manager_sessions_destroy_url
    assert_response :success
  end
end
