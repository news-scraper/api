class TrainingFlowController < ApplicationController
  before_action :set_training_log, only: [:claim, :unclaim, :train, :train_domain]

  def claim
    @training_logs = TrainingLog.claim!(@training_log.root_domain)
    render template: 'training_flow/state_change', locals: {
      state: 'claimed',
      training_logs: @training_logs,
      root_domain: params[:root_domain]
    }
  end

  def unclaim
    @training_logs = TrainingLog.unclaim!(@training_log.root_domain)
    render template: 'training_flow/state_change', locals: {
      state: 'untrained',
      training_logs: @training_logs,
      root_domain: params[:root_domain]
    }
  end

  def train_domain
    @training_logs = TrainingLog.claim!(@training_log.root_domain)
  end

  def train
    @domain = Domain.create_from_params(params, @training_log)
    respond_to do |format|
      if @domain.valid?
        @training_logs = TrainingLog.train!(@training_log.root_domain)
        format.json do
          render template: 'training_flow/state_change', locals: {
            state: 'trained',
            training_logs: @training_logs,
            root_domain: params[:root_domain]
          }
        end
        format.html { redirect_to domains_path }
      else
        format.json { render json: { errors: @domain.errors.full_messages }, status: 422 }
        format.html { render 'train_domain' }
      end
    end
  end

  private

  def set_training_log
    @training_log = TrainingLog.find(params[:id])
  end
end
