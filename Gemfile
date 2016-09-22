source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'jbuilder', '~> 2.5'
gem 'news_scraper', git: 'git@github.com:richardwu/news_scraper.git', branch: 'yield-errors'
gem 'devise', git: 'git@github.com:plataformatec/devise.git'
gem 'turbolinks', '~> 5'

# Assets
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby
gem 'bootstrap', '~> 4.0.0.alpha3'
gem "font-awesome-rails"
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

# Background Jobs
gem 'sidekiq'
gem 'sidekiq-cron'

# Infrastructure
gem 'pg'
gem 'puma', '~> 3.0'
gem 'letsencrypt_plugin'
gem 'ejson'

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
