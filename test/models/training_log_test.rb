require 'test_helper'

class TrainingLogTest < ActiveSupport::TestCase
  test "claim! claims all entries for root_domain" do
    root_domain = training_logs(:untrained).root_domain
    TrainingLog.claim!(root_domain)
    assert TrainingLog.where(root_domain: root_domain).all?(&:claimed?)
  end

  test "unclaim! unclaims all entries for root_domain" do
    root_domain = training_logs(:claimed).root_domain
    TrainingLog.unclaim!(root_domain)
    assert TrainingLog.where(root_domain: root_domain).all?(&:untrained?)
  end

  test "train! trains all entries for root_domain" do
    root_domain = training_logs(:claimed).root_domain
    capture_subprocess_io do
      TrainingLog.train!(root_domain)
    end
    assert TrainingLog.where(root_domain: root_domain).all?(&:trained?)
  end

  test "trained_status checks" do
    assert training_logs(:claimed).claimed?
    assert training_logs(:untrained).untrained?
    assert training_logs(:trained).trained?
  end

  test "create sets entry in redis" do
    log = TrainingLog.create!(
      root_domain: 'google.ca',
      url: 'https://www.google.ca',
      scrape_query_id: scrape_queries(:one).id
    )
    assert_not_nil Api::Application::Redis.get(log.transformed_data_redis_key)
  end

  test "clear_transformed_data! clears key" do
    log = training_logs(:untrained)
    Api::Application::Redis.set(log.transformed_data_redis_key, '1234')
    log.clear_transformed_data!
    assert_nil Api::Application::Redis.get(log.transformed_data_redis_key)
  end
end
