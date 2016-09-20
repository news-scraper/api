require 'test_helper'

class ApiAuthenticationIntegrationTest < ActionDispatch::IntegrationTest
  app_urls = Rails.application.routes.routes.each_with_object([]) do |route, urls|
    # Generate a hash from all the parts (except for format)
    parts = route.parts - [:format]
    parts_hash = parts.zip(parts.map(&:to_s)).to_h

    # defaults includes controller/action, also include format, verb, and parts for that URL
    urls << route.defaults.merge(parts_hash.merge(format: :json, verb: route.verb.downcase)) unless route.verb.empty?
  end

  app_urls.each do |url|
    test "url for #{url[:controller]}/#{url[:action]}/#{url[:verb]} should 401" do
      send(url[:verb], url_for(url))
      assert_response :unauthorized
    end
  end
end
