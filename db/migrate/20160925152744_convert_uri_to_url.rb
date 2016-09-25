class ConvertUriToUrl < ActiveRecord::Migration[5.0]
  def change
    rename_column :training_logs, :uri, :url
    rename_column :news_articles, :uri, :url
  end
end
