require 'test_helper'

class ExposuresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exposure = exposures(:one)
  end

  test "should get index" do
    get exposures_url
    assert_response :success
  end

  test "should get new" do
    get new_exposure_url
    assert_response :success
  end

  test "should create exposure" do
    assert_difference('Exposure.count') do
      post exposures_url, params: { exposure: { build_id: @exposure.build_id, interface_id: @exposure.interface_id } }
    end

    assert_redirected_to exposure_url(Exposure.last)
  end

  test "should show exposure" do
    get exposure_url(@exposure)
    assert_response :success
  end

  test "should get edit" do
    get edit_exposure_url(@exposure)
    assert_response :success
  end

  test "should update exposure" do
    patch exposure_url(@exposure), params: { exposure: { build_id: @exposure.build_id, interface_id: @exposure.interface_id } }
    assert_redirected_to exposure_url(@exposure)
  end

  test "should destroy exposure" do
    assert_difference('Exposure.count', -1) do
      delete exposure_url(@exposure)
    end

    assert_redirected_to exposures_url
  end
end
