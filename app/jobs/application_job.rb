class ApplicationJob < ActiveJob::Base
  sidekiq_options failures: :exhausted
end
