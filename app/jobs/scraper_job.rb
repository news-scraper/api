class ScraperJob < ApplicationJob
  queue_as :default

  def perform(args)
    NewsScraper::Scraper.new(query: args[:query]).scrape do |a|
      case a.class.to_s
      when "NewsScraper::Transformers::ScrapePatternNotDefined"
        Rails.logger.info "#{a.root_domain} was not trained"
        log = TrainingLog.find_or_create_by!(
          root_domain: a.root_domain,
          url: a.url,
          query: args[:query]
        )
        log.transformed_data # Sets the transformed data in redis
      else
        Rails.logger.info "creating article for a[:url]"
        a[:scrape_query] = ScrapeQuery.find_by(query: args[:query])
        NewsArticle.find_or_create_by!(a)
      end
    end
  end
end
