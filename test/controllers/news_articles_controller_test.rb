require 'test_helper'

class NewsArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get articles" do
    get news_articles_url(format: :json, query: 'technology'), headers: authorized_headers
    assert_response :success
  end

  test "should get 404 from articles with scrape query doesn't exist" do
    get news_articles_url(format: :json, query: 'doesnt exist'), headers: authorized_headers
    assert_response :not_found
  end
end
