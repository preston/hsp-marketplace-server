require 'test_helper'

class DependenciesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dependency = dependencies(:one)
  end

  test "should get index" do
    get dependencies_url
    assert_response :success
  end

  test "should get new" do
    get new_dependency_url
    assert_response :success
  end

  test "should create dependency" do
    assert_difference('Dependency.count') do
      post dependencies_url, params: { dependency: { build_id: @dependency.build_id, interface_id: @dependency.interface_id } }
    end

    assert_redirected_to dependency_url(Dependency.last)
  end

  test "should show dependency" do
    get dependency_url(@dependency)
    assert_response :success
  end

  test "should get edit" do
    get edit_dependency_url(@dependency)
    assert_response :success
  end

  test "should update dependency" do
    patch dependency_url(@dependency), params: { dependency: { build_id: @dependency.build_id, interface_id: @dependency.interface_id } }
    assert_redirected_to dependency_url(@dependency)
  end

  test "should destroy dependency" do
    assert_difference('Dependency.count', -1) do
      delete dependency_url(@dependency)
    end

    assert_redirected_to dependencies_url
  end
end
