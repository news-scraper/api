class ScraperJob < ApplicationJob
  queue_as :default

  def perform(args)
    NewsScraper::Scraper.new(query: args[:query]).scrape do |a|
      case a.class
      when NewsScraper::Transformers::ScrapePatternNotDefined
        TrainingLog.find_or_create_by!(
          root_domain: a.root_domain,
          uri: a.uri
        )
      else
        NewsArticle.find_or_create_by!(a)
      end
    end
  end
end
