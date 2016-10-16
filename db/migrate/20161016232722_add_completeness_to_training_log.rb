class AddCompletenessToTrainingLog < ActiveRecord::Migration[5.0]
  def change
    add_column :training_logs, :completeness, :float, default: 0.0
    add_index :training_logs, :completeness
  end
end
