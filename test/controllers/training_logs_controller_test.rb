require 'test_helper'

class TrainingLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @untrained_training_log = training_logs(:untrained)
  end

  test "should get index as html" do
    TrainingLog.any_instance.stubs(:options_for_all_data_types?)
    sign_in users(:one)
    get training_logs_url(format: :html)
    assert_response :success
  end

  test "should get index" do
    get training_logs_url(format: :json), headers: authorized_headers
    assert_response :success
  end

  test "should get show" do
    get training_log_url(id: @untrained_training_log.id, format: :json), headers: authorized_headers
    assert_response :success
  end

  test "should get by_root_domain" do
    get training_log_by_domain_url(root_domain: @untrained_training_log.root_domain, format: :json),
      headers: authorized_headers
    assert_response :success
  end

  test "should create training_log" do
    assert_difference('TrainingLog.count') do
      post training_logs_url(format: :json),
        params: {
          training_log: {
            root_domain: 'test_query',
            url: 'https://www.google.ca',
            query: scrape_queries(:one).query
          }
        },
        headers: authorized_headers
    end

    assert_response 201
  end
end
