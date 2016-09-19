domains = %w(google.ca google.com google.jp)
queries = %w(technology)
statuses = %w(untrained trained claimed).cycle

domains.each do |domain|
  status = statuses.next
  puts "Creating training_log for #{domain} with state #{status}"
  TrainingLog.create(
    root_domain: domain,
    uri: "https://#{domain}/path",
    trained_status: status
  )
end

queries.each do |query|
  puts "Creating ScrapeQuery with query #{query}"
  scrape_query = ScrapeQuery.find_or_create_by(query: 'technology')

  domains.each do |domain|
    puts "Creating news_article for #{domain}"
    scrape_query.news_articles.create(
      author: 'author',
      body: 'body text goes here',
      description: 'description goes here',
      keywords: 'keywords_1,keywords_2',
      section: 'section',
      datetime: DateTime.now,
      title: "Title for #{domain}",
      root_domain: domain,
      uri: "https://#{domain}/path"
    )
  end
end
