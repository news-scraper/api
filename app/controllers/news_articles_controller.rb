class NewsArticlesController < ApplicationController
  def index
    @news_articles = NewsArticle.includes(:scrape_query).all.order(created_at: :desc)
  end

  def articles
    @scrape_query = ScrapeQuery.find_by(query: params[:query])
    if @scrape_query
      @articles = @scrape_query.news_articles
    else
      render json: { error: "No Scrape Query with the query #{params[:query]} was found" },
             status: :not_found
    end
  end
end
