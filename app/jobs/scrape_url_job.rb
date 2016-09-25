class ScrapeUrlJob < ApplicationJob
  queue_as :default

  def perform(args)
    TrainingLog.where(root_domain: args[:root_domain]).each do |log|
      next if NewsArticle.exists?(url: log.url)

      payload = NewsScraper::Extractors::Article.new(url: log.url).extract
      transformed_article = NewsScraper::Transformers::Article.new(
        url: log.url,
        payload: payload
      ).transform
      NewsArticle.create!(transformed_article.merge(scrape_query: log.scrape_query))
    end
  end
end
