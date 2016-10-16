# rubocop:disable Rails/Output

def create_user
  user_params = { email: 'email@example.com', password: 'password', password_confirmation: 'password' }
  puts "Making a default user - #{user_params}"
  User.create(user_params)
end

def create_untrained_logs(scrape_query)
  urls = [
    "http://www.jdpower.com/press-releases/2016-streaming-music-satisfaction-study",
    "http://www.itechpost.com/articles/33077/20160926/why-apples-new-ios-10-safe-backup-issues-security-risks.htm",
    "http://www.teenvogue.com/story/how-to-use-apple-iphone-7",
    "http://blog.elcomsoft.com/2016/09/ios-10-security-weakness-discovered-backup-passwords-much-easier-to-break/",
    "http://www.hotnewhiphop.com/drakes-please-forgive-me-premieres-at-midnight-on-apple-music-news.24323.html",
    "https://www.rt.com/usa/361005-imessage-info-saved-apple/",
    "http://www.thefader.com/2016/09/26/stream-drake-please-forgive-me",
    "http://betanews.com/2016/09/26/apple-buys-tuplejump/",
    "http://www.patentlyapple.com/patently-apple/2016/09/apples-first-store-opened-in-mexico-on-"\
      "saturday-while-tv-host-bill-maher-takes-a-cheap-shot-at-apple-fans.html"
  ]
  statuses = %w(untrained untrainable claimed).cycle

  urls.each do |url|
    status = statuses.next
    domain = url.match(%r{https?://([[a-z]+\.]+[a-z]+).*})[1]
    puts "Creating training_log for #{url} with state #{status}"
    TrainingLog.create(
      root_domain: domain,
      url: url,
      trained_status: status,
      scrape_query_id: scrape_query.id
    )
  end
end

def create_domains
  domains = YAML.load_file(Rails.root.join('db', 'trained.yml'))['domains']
  domains.each do |domain, entries|
    d = Domain.new(root_domain: domain)
    d.save(validate: false)

    entries.each do |entry|
      d.domain_entries.create(entry)
    end
  end
end

def create_trained_logs(query)
  trained = YAML.load_file(Rails.root.join('db', 'trained.yml'))
  trained_logs = trained['training_logs']
  news_articles = trained['articles']
  trained_logs.each do |log|
    t = query.training_logs.create(log)
    article_hash = news_articles.detect { |a| a['url'] == t.url }
    a = NewsArticle.new(article_hash)
    a.training_log = t
    a.save
  end
end

scrape_query = ScrapeQuery.find_or_create_by(query: 'apple')
create_user
create_untrained_logs(scrape_query)
create_domains
create_trained_logs(scrape_query)
