require 'sidekiq/web'

schedule = {
  'scrape_query_scheduler_job' => {
    'cron'        =>  '0 * * * *', # Every hour
    'queue'       =>  'default',
    'class'       =>  'ScrapeQuerySchedulerJob',
    'description' =>  'Schedules Scrape Jobs',
    'active_job'  =>  true
  }
}

if !Rails.env.production?
  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://localhost:6379/12' }
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://localhost:6379/12' }
    Sidekiq::Cron::Job.load_from_hash(schedule)
  end
else
  Sidekiq.configure_client do |config|
    config.redis = { size: 1 }
  end

  Sidekiq.configure_server do |config|
    config.redis = { size: 30 }
    Sidekiq::Cron::Job.load_from_hash(schedule)
  end
end

Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]
