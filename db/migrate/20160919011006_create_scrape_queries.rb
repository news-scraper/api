class CreateScrapeQueries < ActiveRecord::Migration[5.0]
  def change
    create_table :scrape_queries do |t|
      t.string :query, null: false
      t.timestamps
    end

    add_index :scrape_queries, :query, unique: true
  end
end
