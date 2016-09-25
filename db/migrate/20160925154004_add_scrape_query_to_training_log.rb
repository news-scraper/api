class AddScrapeQueryToTrainingLog < ActiveRecord::Migration[5.0]
  def change
    TrainingLog.delete_all
    remove_column :training_logs, :query
    add_reference :training_logs, :scrape_query, index: true
  end
end
