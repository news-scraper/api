class AddIndexToTrainingLogsTrainedStatusUpdatedAt < ActiveRecord::Migration[5.0]
  def change
    add_index :training_logs, [:trained_status, :updated_at]
  end
end
