require 'test_helper'

class VouchersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @voucher = vouchers(:one)
  end

  test "should get index" do
    get vouchers_url
    assert_response :success
  end

  test "should get new" do
    get new_voucher_url
    assert_response :success
  end

  test "should create voucher" do
    assert_difference('Voucher.count') do
      post vouchers_url, params: { voucher: { code: @voucher.code, entitlement_id: @voucher.entitlement_id, expires_at: @voucher.expires_at, issued_at: @voucher.issued_at, product_license_id: @voucher.product_license_id, redeemed_at: @voucher.redeemed_at, redeemed_by: @voucher.redeemed_by } }
    end

    assert_redirected_to voucher_url(Voucher.last)
  end

  test "should show voucher" do
    get voucher_url(@voucher)
    assert_response :success
  end

  test "should get edit" do
    get edit_voucher_url(@voucher)
    assert_response :success
  end

  test "should update voucher" do
    patch voucher_url(@voucher), params: { voucher: { code: @voucher.code, entitlement_id: @voucher.entitlement_id, expires_at: @voucher.expires_at, issued_at: @voucher.issued_at, product_license_id: @voucher.product_license_id, redeemed_at: @voucher.redeemed_at, redeemed_by: @voucher.redeemed_by } }
    assert_redirected_to voucher_url(@voucher)
  end

  test "should destroy voucher" do
    assert_difference('Voucher.count', -1) do
      delete voucher_url(@voucher)
    end

    assert_redirected_to vouchers_url
  end
end
