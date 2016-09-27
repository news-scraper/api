class NewsArticlesController < ApplicationController
  def index
    @news_articles = NewsArticle.includes(:scrape_query)
                                .order(created_at: :desc)
                                .paginate(page: params[:page], per_page: 30)
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
