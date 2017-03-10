require 'test_helper'

class InstancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @instance = instances(:one)
  end

  test "should get index" do
    get instances_url
    assert_response :success
  end

  test "should get new" do
    get new_instance_url
    assert_response :success
  end

  test "should create instance" do
    assert_difference('Instance.count') do
      post instances_url, params: { instance: { build_id: @instance.build_id, deployed_at: @instance.deployed_at, launch_bindings: @instance.launch_bindings, platform_id: @instance.platform_id } }
    end

    assert_redirected_to user_platform_instance_url(@user, @platform, Instance.last)
  end

  test "should show instance" do
    get user_platform_instance_url(@user, @platform, @instance)
    assert_response :success
  end

  test "should get edit" do
    get edit_instance_url(@instance)
    assert_response :success
  end

  test "should update instance" do
    patch user_platform_instance_url(@user, @platform, @instance), params: { instance: { build_id: @instance.build_id, deployed_at: @instance.deployed_at, launch_bindings: @instance.launch_bindings, platform_id: @instance.platform_id } }
    assert_redirected_to user_platform_instance_url(@user, @platform, @instance)
  end

  test "should destroy instance" do
    assert_difference('Instance.count', -1) do
      delete user_platform_instance_url(@user, @platform, @instance)
    end

    assert_redirected_to instances_url
  end
end
