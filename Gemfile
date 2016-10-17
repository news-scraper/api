source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'jbuilder', '~> 2.5'
gem 'news_scraper', git: 'git@github.com:news-scraper/news_scraper.git'
gem 'devise', git: 'git@github.com:plataformatec/devise.git'
gem 'turbolinks', '~> 5'
gem 'will_paginate', '~> 3.1.0'
gem 'blazer', git: 'git@github.com:jules2689/blazer.git'

# Heuristics
gem 'namae'

# Assets
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby
gem 'dashboard', git: 'git@github.com:jules2689/dashboard.git'
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

# Background Jobs
gem 'sidekiq', git: 'git@github.com:jules2689/sidekiq.git'
gem 'sidekiq-cron'
gem 'sinatra', '2.0.0.beta2'

# Infrastructure
gem 'pg'
gem 'puma', '~> 3.0'
gem 'letsencrypt_plugin'
gem 'ejson'

group :development, :test do
  gem 'pry-byebug'
  gem 'rubocop'
end

group :test do
  gem "fakeredis"
  gem 'mocha'
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
