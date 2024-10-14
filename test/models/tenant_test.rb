require "test_helper"

class TenantTest < ActiveSupport::TestCase
  def setup
    @tenant = Tenant.new(
      name: "Test Tenant",
      phone: "1234567890",
      mode: :tenant,
      billing_mode: :shared
    )
  end

  test "domain should be unique within subdomain scope" do
    @tenant.subdomain = "example"
    @tenant.domain = "example.com"
    @tenant.save
    duplicate_tenant = @tenant.dup
    assert_not duplicate_tenant.valid?, "Tenant is valid with a duplicate domain within the same subdomain"
  end

  test "should require both domain and subdomain to be present if subdomain is set" do
    @tenant.subdomain = "example"
    @tenant.domain = nil
    assert_not @tenant.valid?, "Tenant is valid when subdomain is present but domain is missing"
  end

  test "should allow empty subdomain and domain when both are absent" do
    @tenant.subdomain = nil
    @tenant.domain = nil
    assert_not @tenant.valid?, "Tenant is valid without both subdomain and domain"
  end
end
