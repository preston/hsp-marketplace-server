require 'test_helper'

class VouchersControllerTest < ActionDispatch::IntegrationTest
  test 'should get status unauthenticated' do
    get status_path, as: :json
    assert_response :success
    r = json_response
    assert_not_nil r['message']
    assert_not_nil r['product']['datetime']
    assert_not_nil r['database']['datetime']
    assert_nil r['jwt']
    assert_nil r['identity']
    assert_nil r['permissions']
  end

  test 'should get status authenticated' do
    h = jwt_login(:standard)
    get status_path, headers: h, as: :json
    assert_response :success
    r = json_response
    assert_not_nil r['message']
    assert_not_nil r['product']['datetime']
    assert_not_nil r['database']['datetime']
    assert_not_nil r['jwt']['id']
    assert_not_nil r['identity']['user']['id']
    assert_not_nil r['permissions']['everything']
  end
end
