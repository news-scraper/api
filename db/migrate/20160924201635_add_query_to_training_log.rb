class AddQueryToTrainingLog < ActiveRecord::Migration[5.0]
  def change
    add_column :training_logs, :query, :string, index: true
  end
end
