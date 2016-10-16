class ReenqueueTrainingLogs < ActiveRecord::Migration[5.0]
  def change
    TrainingLog.untrained.each do |log|
      TrainingLogRefreshJob.perform_later(training_log_id: log.id)
    end
  end
end
