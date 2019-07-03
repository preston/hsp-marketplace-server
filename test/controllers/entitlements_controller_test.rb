require 'test_helper'

class EntitlementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entitlement = entitlements(:one)
  end

  test "should get index" do
    get entitlements_url
    assert_response :success
  end

  test "should get new" do
    get new_entitlement_url
    assert_response :success
  end

  test "should create entitlement" do
    assert_difference('Entitlement.count') do
      post entitlements_url, params: { entitlement: { product_license_id: @entitlement.product_license_id, user_id: @entitlement.user_id, valid_from: @entitlement.valid_from } }
    end

    assert_redirected_to entitlement_url(Entitlement.last)
  end

  test "should show entitlement" do
    get entitlement_url(@entitlement)
    assert_response :success
  end

  test "should get edit" do
    get edit_entitlement_url(@entitlement)
    assert_response :success
  end

  test "should update entitlement" do
    patch entitlement_url(@entitlement), params: { entitlement: { product_license_id: @entitlement.product_license_id, user_id: @entitlement.user_id, valid_from: @entitlement.valid_from } }
    assert_redirected_to entitlement_url(@entitlement)
  end

  test "should destroy entitlement" do
    assert_difference('Entitlement.count', -1) do
      delete entitlement_url(@entitlement)
    end

    assert_redirected_to entitlements_url
  end
end
