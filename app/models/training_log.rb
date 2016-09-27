class TrainingLog < ApplicationRecord
  include NewsScraper::ExtractorsHelpers

  belongs_to :scrape_query
  validates :url, uniqueness: true
  validates :root_domain, :url, :trained_status, presence: true
  validates :trained_status, inclusion: {
    in: %w(untrained claimed trained untrainable),
    message: '%{value} is not a valid trained status'
  }

  scope :untrained, -> { where(trained_status: 'untrained') }
  scope :claimed, -> { where(trained_status: 'claimed') }
  scope :trained, -> { where(trained_status: 'trained') }
  scope :untrainable, -> { where(trained_status: 'untrainable') }

  after_create :transformed_data # Sets the transformed data in redis

  def trained?
    trained_status == 'trained'
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

  def options_for_all_data_types?
    transformed_data.except('url', 'root_domain').all? do |_, options|
      options.any? { |_, vals| vals['data'].present? }
    end
  end

  def transformed_data
    data = Api::Application::Redis.get("training-#{id}-transformed")
    return JSON.parse(data) if data.present?

    transformed_data = NewsScraper::Transformers::TrainerArticle.new(
      url: url,
      payload: http_request(url).body
    ).transform
    Api::Application::Redis.set("training-#{id}-transformed", transformed_data.to_json)
    transformed_data
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

    def train!(root_domain)
      ScrapeDomainJob.perform_later(root_domain: root_domain)
      where(root_domain: root_domain).update(trained_status: 'trained')
    end
  end
end
