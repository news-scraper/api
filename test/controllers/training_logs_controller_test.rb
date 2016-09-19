require 'test_helper'

class TrainingLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @untrained_training_log = training_logs(:untrained)
  end

  test "should get index" do
    get training_logs_url(format: :json)
    assert_response :success
  end

  test "should get show" do
    get training_log_url(id: @untrained_training_log.id, format: :json)
    assert_response :success
  end

  test "should get by_root_domain" do
    get training_log_by_domain_url(root_domain: @untrained_training_log.root_domain, format: :json)
    assert_response :success
  end

  test "should create training_log" do
    assert_difference('TrainingLog.count') do
      post training_logs_url(format: :json), params: { training_log: { root_domain: 'test_query', uri: 'uri' } }
    end

    assert_response 201
  end

  test "should claim training_logs" do
    assert_difference('TrainingLog.untrained.count', -1) do
      assert_difference('TrainingLog.claimed.count') do
        post claim_training_logs_url(format: :json), params: { root_domain: @untrained_training_log.root_domain }
      end
    end
    assert_response :success
  end

  test "should unclaim training_logs" do
    assert_difference('TrainingLog.claimed.count', -1) do
      assert_difference('TrainingLog.untrained.count') do
        post unclaim_training_logs_url(format: :json), params: { root_domain: training_logs(:claimed).root_domain }
      end
    end
    assert_response :success
  end

  test "should train training_logs" do
    assert_difference('TrainingLog.claimed.count', -1) do
      assert_difference('TrainingLog.trained.count') do
        post train_training_logs_url(format: :json), params: { root_domain: training_logs(:claimed).root_domain }
      end
    end
    assert_response :success
  end
end
