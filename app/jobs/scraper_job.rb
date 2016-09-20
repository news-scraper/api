class ScraperJob < ApplicationJob
  queue_as :default

  def perform(args)
    NewsScraper::Scraper.new(query: args[:query]).scrape do |article_hash|
      NewsArticle.create(article_hash)
    end
  rescue NewsScraper::Transformers::ScrapePatternNotDefined => e
    TrainingLog.create(
      root_domain: e.root_domain,
      uri: e.uri
    )
  end
end
