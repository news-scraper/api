domains = %w(google.ca google.com google.jp)
queries = %w(technology)
statuses = %w(untrained trained claimed).cycle

domains.each do |domain|
  status = statuses.next
  Rails.logger.info "Creating training_log for #{domain} with state #{status}"
  TrainingLog.create(
    root_domain: domain,
    uri: "https://#{domain}/path",
    trained_status: status
  )
end

queries.each do |query|
  Rails.logger.info "Creating ScrapeQuery with query #{query}"
  scrape_query = ScrapeQuery.find_or_create_by(query: 'technology')

  domains.each do |domain|
    Rails.logger.info "Creating news_article for #{domain}"
    scrape_query.news_articles.create(
      author: 'author',
      body: 'body text goes here',
      description: 'description goes here',
      keywords: 'keywords_1,keywords_2',
      section: 'section',
      datetime: DateTime.now.utc,
      title: "Title for #{domain}",
      root_domain: domain,
      uri: "https://#{domain}/path"
    )
  end
end

data_types = NewsScraper.configuration.scrape_patterns['data_types']
%w(shopify.ca).each do |domain|
  Rails.logger.info "Making a domain entry for #{domain}"
  domain_entries_attributes = data_types.collect do |data_type|
    {
      data_type: data_type,
      method: 'css',
      pattern: '.div'
    }
  end
  Domain.create(root_domain: domain, domain_entries_attributes: domain_entries_attributes)
end

user_params = { email: 'email@example.com', password: 'password', password_confirmation: 'password' }
Rails.logger.info "Making a default user - #{user_params}"
User.create(user_params)
