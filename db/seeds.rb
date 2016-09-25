# rubocop:disable Rails/Output
domains = %w(google.ca google.com google.jp)
queries = %w(technology)
statuses = %w(untrained trained claimed).cycle

domains.each do |domain|
  status = statuses.next
  puts "Creating training_log for #{domain} with state #{status}"
  TrainingLog.create(
    root_domain: domain,
    url: "https://#{domain}/path",
    trained_status: status
  )
end

queries.each do |query|
  puts "Creating ScrapeQuery with query #{query}"
  scrape_query = ScrapeQuery.find_or_create_by(query: 'technology')

  domains.each do |domain|
    puts "Creating news_articles for #{domain}"
    3.times do |i|
      scrape_query.news_articles.create!(
        author: 'author',
        body: 'body text goes here',
        description: (['description goes here'] * (1..20).to_a.sample).to_sentence,
        keywords: 'keywords_1,keywords_2',
        section: 'section',
        datetime: DateTime.now.utc,
        title: "Title for #{domain}",
        root_domain: domain,
        url: "https://#{domain}/path/#{i}"
      )
    end
  end
end

data_types = NewsScraper.configuration.scrape_patterns['data_types']
%w(shopify.ca).each do |domain|
  puts "Making a domain entry for #{domain}"
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
puts "Making a default user - #{user_params}"
User.create(user_params)
