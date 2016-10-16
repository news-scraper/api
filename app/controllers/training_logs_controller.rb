class TrainingLogsController < ApplicationController
  before_action :set_training_log, only: [:show, :train_domain, :train, :claim, :unclaim]

  def index
    params[:log_type] ||= 'untrained'
    @training_logs = TrainingLog.logs(params[:log_type])
                                .paginate(page: params[:page])
                                .order(completeness: :desc)
  end

  def show
  end

  def create
    @training_log = TrainingLog.new(training_log_params)
    @training_log.scrape_query = ScrapeQuery.find_by(query: params[:training_log][:query])

    if @training_log.save
      render :show, status: :created, location: @training_log
    else
      render json: @training_log.errors, status: :unprocessable_entity
    end
  end

  def by_root_domain
    @training_logs = TrainingLog.where(root_domain: params[:root_domain])
    render :index
  end

  private

  def set_training_log
    @training_log = TrainingLog.find(params[:id])
  end

  def training_log_params
    params.require(:training_log).permit(:root_domain, :url).except(:query)
  end
end
