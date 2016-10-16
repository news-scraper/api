class TrainingLogRefreshJob < ApplicationJob
  queue_as :default

  def perform(args)
    training_log = TrainingLog.find(args[:training_log_id])
    Api::Application::Redis.set(training_log.transformed_data_redis_key, nil)
    training_log.transformed_data
  end
end
