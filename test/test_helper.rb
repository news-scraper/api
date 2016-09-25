ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'fakeredis/minitest'

module ActiveSupport
  class TestCase
    fixtures :all

    def authorized_headers
      { 'Authorization' => "Token token=#{users(:one).api_key}" }
    end
  end
end

module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers
  end
end
