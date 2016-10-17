class ScraperJob < ApplicationJob
  queue_as :default

  def perform(args)
    scrape_query = ScrapeQuery.find_or_create_by!(query: args[:query])

    NewsScraper::Scraper.new(query: args[:query]).scrape do |a|
      case a.class.to_s
      when "NewsScraper::Transformers::ScrapePatternNotDefined"
        Rails.logger.info "#{a.root_domain} was not trained"
        find_or_create_log(url: a.url, root_domain: a.root_domain, scrape_query: scrape_query)
      when "NewsScraper::ResponseError"
        Rails.logger.error "#{a.url} returned an error: #{a.error_code}-#{a.message}"
      else
        Rails.logger.info "Creating article for #{a[:url]}"
        unless TrainingLog.exists?(root_domain: a[:root_domain], url: a[:url])
          Rails.logger.error "TrainingLog somehow didn't exist for #{a[:root_domain]}"
          find_or_create_log(
            url: a[:url],
            root_domain: a[:root_domain],
            scrape_query: scrape_query,
            trained_status: 'trained'
          )
        end

        unless NewsArticle.exists?(url: a[:url])
          NewsArticle.create!(a.merge(scrape_query_id: scrape_query.id))
        end
      end
    end
  end

  def find_or_create_log(url:, root_domain:, scrape_query:, trained_status: 'untrained')
    if TrainingLog.exists?(url: url)
      TrainingLog.find_by(url: url)
    else
      params = {
        root_domain: root_domain,
        url: url,
        scrape_query_id: scrape_query.id
      }
      params[:trained_status] = if TrainingLog.find_by(root_domain: root_domain).try(:untrainable?)
        'untrainable'
      else
        trained_status
      end
      TrainingLog.create!(params)
    end
  rescue ActiveRecord::RecordNotUnique
    TrainingLog.find_by(url: url)
  end
end
