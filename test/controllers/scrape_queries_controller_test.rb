require 'test_helper'

class ScrapeQueriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scrape_query = scrape_queries(:one)
  end

  test "should get index" do
    get scrape_queries_url(format: :json), headers: authorized_headers
    assert_response :success
  end

  test "should create scrape_query" do
    assert_difference('ScrapeQuery.count') do
      post scrape_queries_url(format: :json),
        params: { scrape_query: { query: 'test_query' } },
        headers: authorized_headers
    end

    assert_response 201
  end

  test "should destroy scrape_query" do
    assert_difference('ScrapeQuery.count', -1) do
      delete scrape_query_url(@scrape_query, format: :json), headers: authorized_headers
    end

    assert_response 204
  end
end
