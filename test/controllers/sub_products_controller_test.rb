require 'test_helper'

class SubProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sub_product = sub_products(:one)
  end

  test "should get index" do
    get sub_products_url
    assert_response :success
  end

  test "should get new" do
    get new_sub_product_url
    assert_response :success
  end

  test "should create sub_product" do
    assert_difference('SubProduct.count') do
      post sub_products_url, params: { sub_product: { child_id: @sub_product.child_id, parent_id: @sub_product.parent_id } }
    end

    assert_redirected_to sub_product_url(SubProduct.last)
  end

  test "should show sub_product" do
    get sub_product_url(@sub_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_sub_product_url(@sub_product)
    assert_response :success
  end

  test "should update sub_product" do
    patch sub_product_url(@sub_product), params: { sub_product: { child_id: @sub_product.child_id, parent_id: @sub_product.parent_id } }
    assert_redirected_to sub_product_url(@sub_product)
  end

  test "should destroy sub_product" do
    assert_difference('SubProduct.count', -1) do
      delete sub_product_url(@sub_product)
    end

    assert_redirected_to sub_products_url
  end
end
