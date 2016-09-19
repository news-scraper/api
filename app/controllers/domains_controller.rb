class DomainsController < ApplicationController
  before_action :set_domain, only: [:show, :update, :destroy]

  def index
    @domains = Domain.includes(:domain_entries).all
  end

  def show
  end

  def create
    @domain = Domain.new(domain_params)

    if @domain.save
      render :show, status: :created, location: @domain
    else
      render json: @domain.errors, status: :unprocessable_entity
    end
  end

  def update
    if @domain.update(domain_params)
      render :show, status: :ok, location: @domain
    else
      render json: @domain.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @domain.destroy
  end

  private

  def set_domain
    @domain = Domain.includes(:domain_entries).find(params[:id])
  end

  def domain_params
    params.require(:domain).permit(:root_domain, domain_entries_attributes: [:data_type, :method, :pattern])
  end
end
