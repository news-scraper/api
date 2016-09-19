class NewsArticle < ApplicationRecord
  validates :root_domain, :uri, presence: true
  validates :uri, uniqueness: true
  belongs_to :scrape_query
end
