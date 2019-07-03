require 'test_helper'

class ProductLicensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_license = product_licenses(:one)
  end

  test "should get index" do
    get product_licenses_url
    assert_response :success
  end

  test "should get new" do
    get new_product_license_url
    assert_response :success
  end

  test "should create product_license" do
    assert_difference('ProductLicense.count') do
      post product_licenses_url, params: { product_license: { external_id: @product_license.external_id, license_id: @product_license.license_id, product_id: @product_license.product_id } }
    end

    assert_redirected_to product_license_url(ProductLicense.last)
  end

  test "should show product_license" do
    get product_license_url(@product_license)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_license_url(@product_license)
    assert_response :success
  end

  test "should update product_license" do
    patch product_license_url(@product_license), params: { product_license: { external_id: @product_license.external_id, license_id: @product_license.license_id, product_id: @product_license.product_id } }
    assert_redirected_to product_license_url(@product_license)
  end

  test "should destroy product_license" do
    assert_difference('ProductLicense.count', -1) do
      delete product_license_url(@product_license)
    end

    assert_redirected_to product_licenses_url
  end
end
