class NewsArticle < ApplicationRecord
  validates :root_domain, :url, presence: true
  validates :url, uniqueness: true
  belongs_to :scrape_query
end
