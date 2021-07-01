ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # ActiveRecord::Migration.check_pending!

  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  setup :load_seeds

  # Add more helper methods to be used by all tests here...

  def jwt_login(type)
    @jwt_user = nil
    @jwt_identity = nil
    case type
    when :administrator
      @jwt_user = User.where(name: 'Alice Administrator').first
    when :editor
      @jwt_user = User.where(name: 'Ethan Editor').first
    else :standard
         @jwt_user = User.where(name: 'Simple User').first
    end
    @jwt_identity = @jwt_user.identities.first
    @jwt = JsonWebToken.create!(identity: @jwt_identity, expires_at: 1.day.from_now)
    { 'Authorization': "Bearer #{@jwt.encode}" }
    # headers 'Authorization', 'Bearer ' +jwt.encode
    # byebug
    # request.env['HTTP_AUTHORIZATION'] = (token.nil? ? refresh_jwt_token : token)
  end

  # @token = nil
  # def refresh_jwt_token_standard
  #   refresh_jwt_token(email = 'standard@example.com', password = 'password')
  # end

  # def refresh_jwt_token_service
  #   refresh_jwt_token(email = 'service@example.com', password = 'password')
  # end

  # def refresh_jwt_token(email = 'admin@example.com', password = 'password')
  #   if @token.nil?
  #     orig = @controller
  #     @controller = SessionsController.new
  #     post :create, params: { email: email, password: password }, format: :json
  #     assert_response :success
  #     @token = "Bearer #{json_response['token']}"
  #     @controller = orig
  #     @jwt_user = json_response['user']
  #   end
  #   @token
  # end

  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  def load_seeds
    load "#{Rails.root}/db/seeds.rb"
  end

  # def assert_options_headers(action)
  #   process 'OPTIONS', action
  #   assert_response :success
  #   validate_cors_headers_in_response
  # end

  def validate_cors_headers_in_response
    assert_equal '*', @response.header['Access-Control-Allow-Origin']
    assert_not_nil @response.header['Access-Control-Max-Age']
    methods = @response.header['Access-Control-Allow-Methods'].split(/,\s*/)
    %w[INDEX GET POST PUT DELETE].each do |m|
      assert methods.include? m
    end
    allowed_headers = @response.header['Access-Control-Allow-Headers'].split(/,\s*/)
    %w[Origin X-Requested-With Content-Type Accept Authorization].each do |h|
      assert allowed_headers.include? h
    end
  end

  def assert_response_fields(expected, _actual)
    expected.each do |k, _v|
      e = expected[k]
      a = json_response[k.to_s]
      if e.instance_of?(ActiveSupport::TimeWithZone)
        # byebug
        assert_equal e.to_i, Time.zone.parse(a).to_i
      else
        assert_equal e, a
      end
    end
  end

  # def assert_date_order(date_field, array, asc = true)
  #   previous = nil
  #   array.each do |n|
  #     next if previous.nil?

  #     if asc
  #       assert Date.parse(n[date_field]) <= Date.parse(prev[date_field])
  #     else
  #       assert Date.parse(n[date_field]) >= Date.parse(prev[date_field])
  #     end
  #     previous = n
  #   end
  # end
end
