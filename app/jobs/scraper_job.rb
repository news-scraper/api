class ScraperJob < ApplicationJob
  queue_as :default

  def perform(args)
    scrape_query = ScrapeQuery.find_by(query: args[:query])

    NewsScraper::Scraper.new(query: args[:query]).scrape do |a|
      case a.class.to_s
      when "NewsScraper::Transformers::ScrapePatternNotDefined"
        Rails.logger.info "#{a.root_domain} was not trained"
        TrainingLog.create!(
          root_domain: a.root_domain,
          url: a.url,
          scrape_query_id: scrape_query.id
        ) unless TrainingLog.exists?(url: a.url)
      else
        Rails.logger.info "creating article for a[:url]"
        NewsArticle.create!(a.merge(scrape_query_id: scrape_query.id)) unless NewsArticle.exist?(url: a[:url])
      end
    end
  end
end
