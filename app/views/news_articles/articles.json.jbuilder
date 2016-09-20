json.scrape_query @scrape_query, partial: 'scrape_queries/scrape_query', as: :scrape_query
json.articles do
  json.array! @articles, partial: 'news_articles/news_article', as: :news_article
end
