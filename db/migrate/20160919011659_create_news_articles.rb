class CreateNewsArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :news_articles do |t|
      t.string :author, index: true
      t.text :body
      t.text :description
      t.text :keywords
      t.string :section
      t.datetime :datetime, index: true
      t.string :title, index: true
      t.string :root_domain, index: true, null: false
      t.string :uri, null: false
      t.references :scrape_query, index: true

      t.timestamps
    end

    add_index :news_articles, :uri, unique: true
  end
end
