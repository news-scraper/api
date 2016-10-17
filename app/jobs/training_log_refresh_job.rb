class TrainingLogRefreshJob < ApplicationJob
  queue_as :default

  def perform(args)
    training_log = TrainingLog.find(args[:training_log_id])
    training_log.clear_transformed_data!
    training_log.transformed_data
  end
end
