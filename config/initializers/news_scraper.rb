NewsScraper.configure do |config|
  config.scrape_patterns['domains'] = Domain.hash
end
