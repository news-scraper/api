class ScraperJob < ApplicationJob
  queue_as :default

  def perform(args)
    scrape_query = ScrapeQuery.find_or_create_by!(query: args[:query])

    NewsScraper::Scraper.new(query: args[:query]).scrape do |a|
      case a.class.to_s
      when "NewsScraper::Transformers::ScrapePatternNotDefined"
        Rails.logger.info "#{a.root_domain} was not trained"
        unless TrainingLog.exists?(url: a.url)
          params = {
            root_domain: a.root_domain,
            url: a.url,
            scrape_query_id: scrape_query.id
          }
          params[:trained_status] = 'untrainable' if TrainingLog.find_by(root_domain: a.root_domain).try(:untrainable?)
          TrainingLog.create!(params)
        end
      when "NewsScraper::ResponseError"
        Rails.logger.error "#{a.url} returned an error: #{a.error_code}-#{a.message}"
      else
        Rails.logger.info "creating article for #{a[:url]}"
        NewsArticle.create!(a.merge(scrape_query_id: scrape_query.id)) unless NewsArticle.exists?(url: a[:url])
      end
    end
  end
end
