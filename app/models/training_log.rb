class TrainingLog < ApplicationRecord
  validates :uri, uniqueness: true
  validates :root_domain, :uri, :trained_status, presence: true
  validates :trained_status, inclusion: {
    in: %w(untrained claimed trained),
    message: '%{value} is not a valid trained status'
  }

  scope :untrained, -> { where(trained_status: 'untrained') }
  scope :claimed, -> { where(trained_status: 'claimed') }
  scope :trained, -> { where(trained_status: 'trained') }

  def trained?
    trained_status == 'trained'
  end

  def claimed?
    trained_status == 'claimed'
  end

  def untrained?
    trained_status == 'untrained'
  end

  class << self
    def claim!(root_domain)
      where(root_domain: root_domain).update(trained_status: 'claimed')
    end

    def unclaim!(root_domain)
      where(root_domain: root_domain).update(trained_status: 'untrained')
    end

    def train!(root_domain)
      where(root_domain: root_domain).update(trained_status: 'trained')
    end
  end
end
