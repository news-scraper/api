class AddIndexToNewsArticlesCreatedAt < ActiveRecord::Migration[5.0]
  def change
    add_index :news_articles, :created_at
  end
end
