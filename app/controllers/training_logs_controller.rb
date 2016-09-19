class TrainingLogsController < ApplicationController
  def index
    @training_logs = TrainingLog.all
  end

  def show
    @training_log = TrainingLog.find(params[:id])
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

  def claim
    @training_logs = TrainingLog.claim!(params[:root_domain])
    render template: 'training_logs/state_change', locals: {
      state: 'claimed',
      training_logs: @training_logs,
      root_domain: params[:root_domain]
    }
  end

  def unclaim
    @training_logs = TrainingLog.unclaim!(params[:root_domain])
    render template: 'training_logs/state_change', locals: {
      state: 'untrained',
      training_logs: @training_logs,
      root_domain: params[:root_domain]
    }
  end

  def train
    @training_logs = TrainingLog.train!(params[:root_domain])
    render template: 'training_logs/state_change', locals: {
      state: 'trained',
      training_logs: @training_logs,
      root_domain: params[:root_domain]
    }
  end

  private

  def training_log_params
    params.require(:training_log).permit(:root_domain, :uri)
  end
end
