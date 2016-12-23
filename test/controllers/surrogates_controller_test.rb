require 'test_helper'

class SurrogatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @surrogate = surrogates(:one)
  end

  test "should get index" do
    get surrogates_url
    assert_response :success
  end

  test "should get new" do
    get new_surrogate_url
    assert_response :success
  end

  test "should create surrogate" do
    assert_difference('Surrogate.count') do
      post surrogates_url, params: { surrogate: { interface_id: @surrogate.interface_id, substitute_id: @surrogate.substitute_id } }
    end

    assert_redirected_to surrogate_url(Surrogate.last)
  end

  test "should show surrogate" do
    get surrogate_url(@surrogate)
    assert_response :success
  end

  test "should get edit" do
    get edit_surrogate_url(@surrogate)
    assert_response :success
  end

  test "should update surrogate" do
    patch surrogate_url(@surrogate), params: { surrogate: { interface_id: @surrogate.interface_id, substitute_id: @surrogate.substitute_id } }
    assert_redirected_to surrogate_url(@surrogate)
  end

  test "should destroy surrogate" do
    assert_difference('Surrogate.count', -1) do
      delete surrogate_url(@surrogate)
    end

    assert_redirected_to surrogates_url
  end
end
