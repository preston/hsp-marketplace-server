require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  def setup
    # @user_admin = User.first
    # # @user_current =
    @template = { name: 'great product' }
  end

  def teardown
    #   validate_cors_headers_in_response if response.success?
  end

  # test 'index respond to CORS preflight requests' do
  # get products_path, as: :json
  # validate_cors_headers_in_response
  #   process 'OPTIONS', products_path
  #   assert_response :success
  #   validate_cors_headers_in_response
  # end

  def assert_unacceptable_get(path)
    get path, as: :html
    assert_response :not_acceptable
  end

  test 'no html' do
    assert_unacceptable_get(products_path)
    assert_unacceptable_get(products_path(Product.where(published_at: nil)))
  end

  test 'index should only get published, visible products' do
    get products_path, as: :json
    assert_response :success
    assert assigns(:products)
    r = json_response['results']
    assert_equal Product.where.not(published_at: nil).where.not(visible_at: nil).count, r.length
  end

  test 'should get paginated index when requested' do
    # jwt_login
    get products_path(per_page: 5), as: :json
    r = json_response
    assert_response :success
    assert_not_nil assigns(:products)
    assert_nil r['previous_page']
    assert_equal 1, r['current_page']
    assert_equal 2, r['next_page']
    assert_equal 2, r['total_pages']
    assert_equal 7, r['total_entries']
    assert_equal 5, r['results'].length

    # Now let's play with the page size.
    get products_path(per_page: Product.count), as: :json
    r = json_response
    assert_response :success
    assert_not_nil assigns(:products)
    assert_equal where_published.count, r['results'].length
    assert_nil r['previous_page']
    assert_equal 1, r['current_page']
    assert_nil r['next_page']
    assert_equal 1, r['total_pages']

    # Same thing but smaller page size
    get products_path(page: 1, per_page: 2), as: :json
    r = json_response
    assert_response :success
    assert_not_nil assigns(:products)
    assert_equal 2, r['results'].length
    assert_equal 4, r['total_pages']

    # Try a page far past the end of the result set.
    get products_path(page: Product.count, per_page: Product.count), as: :json
    r = json_response
    assert_response :success
    assert_not_nil assigns(:products)
    assert_equal 0, r['results'].length
    assert_equal Product.count - 1, r['previous_page']
    assert_equal Product.count, r['current_page']
    assert_nil r['next_page']
    assert_equal 1, r['total_pages']
  end

  test 'should support sort and order options' do
    # jwt_login
    get products_path, as: :json
    assert_equal 'CQL Translation Product', json_response['results'][0]['name']

    get products_path(sort: 'name', order: 'desc'), as: :json
    assert_equal 'Patient Data Exchange Formulary Client', json_response['results'][0]['name']

    get products_path(sort: 'description', order: 'asc'), as: :json
    assert_equal where_published.order(description: :asc).first.description, json_response['results'][0]['description']

    get products_path(sort: 'description', order: 'desc'), as: :json
    assert_equal where_published.order(description: :desc).first.description, json_response['results'][0]['description']
  end

  def where_published
    Product.where.not(published_at: nil).where.not(visible_at: nil)
  end

  test 'should support free text search' do
    #   jwt_login
    q = 'marketplace'
    post search_products_path(text: q), as: :json
    r = json_response['results']
    assert_equal 2, r.length
    assert_match /Marketplace.*/, r[0]['name']
    assert_match /Marketplace.*/, r[1]['name']
  end

  test 'should permit getting a published visible products anonymously' do
    p = where_published.first
    get product_path(p), as: :json
    assert_response :success
    r = json_response
    assert_equal p.id, r['id']
  end

  test 'should not permit getting unpublished or invisible product anonymously' do
    p = Product.where(published_at: nil).first
    get product_path(p), as: :json
    assert_response :unauthorized

    p = Product.where(visible_at: nil).first
    get product_path(p), as: :json
    assert_response :unauthorized
  end

  test 'should not create product anonymously' do
    assert_no_difference('Product.count') do
      post products_path(product: { name: 'blah' }.merge!(@template)), as: :json
      assert_response :unauthorized
    end
  end

  test 'should create product with only name' do
    h = jwt_login(:editor)
    assert_difference('Product.count', 1) do
      post products_path, params: { product: { name: 'foo', user_id: @jwt_user.id } }, headers: h, as: :json
      assert_response :success
    end
    assert_difference('Product.count', 1) do
      post products_path, params: { product: { name: 'foo2', user_id: @jwt_user.id, description: 'big foozle' } },
                          headers: h, as: :json
      assert_response :success
    end
  end

  test 'should not create invalid product' do
    h = jwt_login(:editor)
    assert_no_difference('Product.count') do
      post products_path, params: { product: { name: nil, user_id: @jwt_user.id } }, headers: h, as: :json
      assert_response :unprocessable_entity
    end
  end

  test 'should show own unpublished product when authenticated' do
    h = jwt_login(:standard)
    p = @jwt_user.products.where(published_at: nil).first
    get product_path(p), headers: h, as: :json
    r = json_response
    assert_response :success
    assert_not_nil json_response['name']
  end

  test 'should not update product when unauthenticated' do
    p = Product.first
    orig = p.name
    patch product_path(p), params: { product: { id: p.id, name: 'h4x0r' } }, as: :json
    assert_response :unauthorized
    assert_equal orig, Product.first.name
  end

  test 'should update product' do
    h = jwt_login(:editor)
    p = Product.first
    expected = {
      description: 'new description',
      name: 'great name',
      external_id: 'new external_id',
      locale: 'es'
    }
    assert_no_difference('Product.count') do
      patch product_path(p), params: { id: p.id, product: expected }, headers: h, as: :json
      assert_response :success
    end
    assert_response_fields(expected, json_response)
  end

  test 'should not update product to invalid state' do
    h = jwt_login(:editor)
    p = Product.first
    assert_no_difference('Product.count') do
      # This first ones are ok.
      patch product_path(p), params: { id: p, product: { description: nil, external_id: nil } }, headers: h, as: :json
      assert_response :success

      # But not the name!
      patch product_path(p), params: { id: p, product: { name: nil } }, headers: h, as: :json
      assert_response :unprocessable_entity
    end
    # assert_response_fields(expected, json_response)
    # assert_equal new_name, json_response['name']
  end

  test 'should destroy product when administrator' do
    h = jwt_login(:administrator)
    p = Product.first
    assert_difference('Product.count', -1) do
      delete product_path(p), headers: h, as: :json
      assert_response :success
      assert_equal p.name, json_response['name']
    end
  end

  test 'should destroy product when editor' do
    h = jwt_login(:editor)
    p = Product.first
    assert_difference('Product.count', -1) do
      delete product_path(p), headers: h, as: :json
      assert_response :success
      assert_equal p.name, json_response['name']
    end
  end

  test 'should not destroy product when anonymous or unauthorized' do
    p = Product.first
    assert_no_difference('Product.count') do
      delete product_path(p), as: :json
      assert_response :unauthorized
    end
    h = jwt_login(:standard)
    assert_no_difference('Product.count') do
      delete product_path(p), headers: h, as: :json
      assert_response :unauthorized
    end
  end

  # Versioning stuff not needed now.

  # test 'should get most recent versions by default' do
  #   jwt_login
  #   product = Product.find_by_external_id('unused')
  #   get :versions, params: { id: Product.find_by_external_id('unused') }, as: :json

  #   assert_equal	4,	product.versions.count
  #   assert_equal	'for version testing', json_response['versions'][0]['product']['external_id']
  #   assert_equal	'Unlicensed Orphan Product', json_response['versions'][0]['product']['name']
  # end

  # test 'should allow overriding default version limit' do
  #   jwt_login
  #   product = Product.find_by_external_id('unused')

  #   get :versions, params: { id: Product.find_by_external_id('unused'), limit: -9 }, as: :json
  #   assert_response	:unprocessable_entity
  #   assert_nil	json_response['versions']

  #   get :versions, params: { id: Product.find_by_external_id('unused'), limit: 'bob' }, as: :json
  #   assert_response	:unprocessable_entity
  #   assert_nil	json_response['versions']

  #   get :versions, params: { id: Product.find_by_external_id('unused'), limit: '2bob' }, as: :json
  #   assert_response	:unprocessable_entity
  #   assert_nil	json_response['versions']

  #   get :versions, params: { id: Product.find_by_external_id('unused'), limit: 0 }, as: :json
  #   assert_response	:success
  #   assert_equal	0,	json_response['versions'].count

  #   get :versions, params: { id: Product.find_by_external_id('unused'), limit: '2' }, as: :json
  #   assert_response	:success
  #   assert_equal	2,	json_response['versions'].count

  #   get :versions, params: { id: Product.find_by_external_id('unused'), limit: 99 }, as: :json
  #   assert_response	:success
  #   assert_equal	4,	json_response['versions'].count
  #   assert_equal	'for version testing', json_response['versions'][0]['product']['external_id']
  #   assert_equal	'Unlicensed Orphan Product', json_response['versions'][0]['product']['name']
  # end

  # def validate_version
  #   assert_response	:success
  #   assert_not_nil	json_response['user_id']
  #   assert_not_nil	json_response['datetime']
  #   assert_equal	'update', json_response['event']
  #   assert_equal	3, json_response['index']
  #   assert_equal	'Unlicensed Orphan Product', json_response['product']['name']
  #   assert_equal	'for version testing', json_response['product']['external_id']
  # end

  # test 'should get last version' do
  #   jwt_login
  #   product = Product.find_by_external_id('unused')

  #   get :version, params: { id: Product.find_by_external_id('unused'), version: :last }, as: :json
  #   validate_version

  #   get :version, params: { id: Product.find_by_external_id('unused'), version: 3 }, as: :json
  #   validate_version

  #   get :version, params: { id: Product.find_by_external_id('unused'), version: -1 }, as: :json
  #   validate_version

  #   get :version, params: { id: Product.find_by_external_id('unused'), version: 0 }, as: :json
  #   assert_nil	json_response['product']
  # end

  # test 'should not get invalid versions' do
  #   jwt_login
  #   product = Product.find_by_external_id('unused')

  #   get :version, params: { id: Product.find_by_external_id('unused'), version: 'bob' }, as: :json
  #   assert_response :not_found

  #   get :version, params: { id: Product.find_by_external_id('unused'), version: 42 }, as: :json
  #   assert_response :not_found
  # end
end
