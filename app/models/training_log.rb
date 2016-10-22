class TrainingLog < ApplicationRecord
  include NewsScraper::ExtractorsHelpers
  include TrainingFlow

  belongs_to :scrape_query
  has_many :news_articles, foreign_key: :root_domain, primary_key: :root_domain

  validates :url, uniqueness: true
  validates :root_domain, :url, :trained_status, presence: true
  validates :trained_status, inclusion: {
    in: %w(untrained claimed trained untrainable),
    message: '%{value} is not a valid trained status'
  }

  scope :untrained,              -> { where(trained_status: 'untrained') }
  scope :claimed,                -> { where(trained_status: 'claimed') }
  scope :trained,                -> { where(trained_status: 'trained') }
  scope :automatically_trained,  -> { where(trained_status: 'automatically_trained') }
  scope :untrainable,            -> { where(trained_status: 'untrainable') }

  after_create :transformed_data # Sets the transformed data in redis

  def self.logs(log_type)
    case log_type.downcase
    when 'untrained'
      untrained
    when 'claimed'
      claimed
    when 'trained'
      trained
    when 'untrainable'
      untrainable
    when 'automatically_trained'
      automatically_trained
    else
      untrained
    end
  end

  def trained?
    trained_status == 'trained'
  end

  def automatically_trained?
    trained_status == 'automatically_trained'
  end

  def claimed?
    trained_status == 'claimed'
  end

  def untrained?
    trained_status == 'untrained'
  end

  def untrainable?
    trained_status == 'untrainable'
  end

  class << self
    def claim!(root_domain)
      where(root_domain: root_domain).update(trained_status: 'claimed')
    end

    def unclaim!(root_domain)
      where(root_domain: root_domain).update(trained_status: 'untrained')
    end

    def untrainable!(root_domain)
      where(root_domain: root_domain).update(trained_status: 'untrainable')
    end

    def train!(root_domain, trained_status = 'trained')
      ScrapeDomainJob.perform_later(root_domain: root_domain)
      where(root_domain: root_domain).update(trained_status: trained_status)
    end

    def auto_train!(root_domain)
      train!(root_domain, 'automatically_trained')
    end
  end
end
