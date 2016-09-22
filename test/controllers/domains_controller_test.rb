require 'test_helper'

class DomainsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @domain = domains(:one)
  end

  test "should get index as html" do
    sign_in users(:one)
    get domains_url(format: :html)
    assert_response :success
  end

  test "should get index" do
    get domains_url(format: :json), headers: authorized_headers
    assert_response :success
  end

  test "should create domain" do
    domain_entries = NewsScraper.configuration.scrape_patterns['data_types'].each_with_object([]) do |dt, acc|
      acc << {
        data_type: dt,
        method: 'css',
        pattern: '.div'
      }
    end

    assert_difference('Domain.count') do
      post domains_url(format: :json), params: {
        domain: {
          root_domain: 'new_example.com',
          domain_entries_attributes: domain_entries
        }
      }, headers: authorized_headers
    end

    assert_response 201
  end

  test "should show domain" do
    get domain_url(@domain, format: :json), headers: authorized_headers
    assert_response :success
  end

  test "should update domain" do
    patch domain_url(@domain, format: :json),
      params: { domain: { root_domain: @domain.root_domain } },
      headers: authorized_headers
    assert_response 200
  end

  test "should destroy domain" do
    assert_difference('Domain.count', -1) do
      delete domain_url(@domain, format: :json), headers: authorized_headers
    end
    assert_response 204
  end
end
