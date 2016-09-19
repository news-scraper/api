class ScrapeQueriesController < ApplicationController
  before_action :set_scrape_query, only: [:show, :destroy]

  def index
    @scrape_queries = ScrapeQuery.all
  end

  def show
  end

  def create
    @scrape_query = ScrapeQuery.new(scrape_query_params)

    if @scrape_query.save
      render :show, status: :created, location: @scrape_query
    else
      render json: @scrape_query.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @scrape_query.destroy
  end

  private

  def set_scrape_query
    @scrape_query = ScrapeQuery.find(params[:id])
  end

  def scrape_query_params
    params.require(:scrape_query).permit(:query)
  end
end
