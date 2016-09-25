class ScrapeUrlJob < ApplicationJob
  queue_as :default

  def perform(args)
    payload = NewsScraper::Extractors::Article.new(url: args[:url]).extract
    transformed_article = NewsScraper::Transformers::Article.new(
      url: args[:url],
      payload: payload
    ).transform
    transformed_article[:scrape_query] = ScrapeQuery.find_by(query: args[:query])
    NewsArticle.create!(transformed_article) unless NewsArticle.exists?(url: args[:url])
  end
end
