class NewsArticle < ApplicationRecord
  validates :root_domain, :url, presence: true
  validates :url, uniqueness: true
  belongs_to :scrape_query
  belongs_to :news_articles, foreign_key: :root_domain, primary_key: :root_domain
end
