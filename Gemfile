source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'pg'
gem 'puma', '~> 3.0'
gem 'jbuilder', '~> 2.5'
gem 'news_scraper', git: 'git@github.com:richardwu/news_scraper.git', branch: 'yield-errors'

gem 'sidekiq'
gem 'sidekiq-cron'

gem 'letsencrypt_plugin'

group :development, :test do
  gem 'pry-byebug'
  gem 'rubocop'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
  gem 'capistrano-chruby'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
