class ScrapeQuerySchedulerJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    ScrapeQuery.all.each do |scrape_query|
      ScraperJob.perform_later(query: scrape_query.query)
    end
  end
end
