class ScrapeQuery < ApplicationRecord
  validates :query, uniqueness: true, presence: true
  has_many :news_articles
end
