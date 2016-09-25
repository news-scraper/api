class TrainingLogsController < ApplicationController
  before_action :set_training_log, only: [:show, :train_domain, :train, :claim, :unclaim]

  def index
    @training_logs = TrainingLog.untrained
    @claimed_logs = TrainingLog.claimed
  end

  def show
  end

  def create
    @training_log = TrainingLog.new(training_log_params)

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
    params.require(:training_log).permit(:root_domain, :url)
  end
end
