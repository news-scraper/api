require 'test_helper'

class TrainingFlowControllerTest < ActionDispatch::IntegrationTest
  setup do
    @untrained_training_log = training_logs(:untrained)
  end

  test "should claim training_logs" do
    assert_difference('TrainingLog.untrained.count', -1) do
      assert_difference('TrainingLog.claimed.count') do
        post claim_training_logs_url(id: @untrained_training_log.id, format: :json),
          params: { root_domain: @untrained_training_log.root_domain },
          headers: authorized_headers
      end
    end
    assert_response :success
  end

  test "should unclaim training_logs" do
    assert_difference('TrainingLog.claimed.count', -1) do
      assert_difference('TrainingLog.untrained.count') do
        post unclaim_training_logs_url(id: training_logs(:claimed).id, format: :json),
          params: { root_domain: training_logs(:claimed).root_domain },
          headers: authorized_headers
      end
    end
    assert_response :success
  end

  test "should train training_logs" do
    claimed = training_logs(:claimed)
    Api::Application::Redis.set("training-#{claimed.id}-transformed", file_fixture('transformed.json').read)

    assert_difference('TrainingLog.claimed.count', -1) do
      assert_difference('TrainingLog.trained.count') do
        post train_training_logs_url(id: claimed.id, format: :json),
          params: {
            root_domain: claimed.root_domain,
            training_log: {
              author: {
                option: 'css',
                css: '.pattern'
              },
              body: {
                option: 'css',
                css: '.pattern'
              },
              description: {
                option: 'css',
                css: '.pattern'
              },
              keywords: {
                option: 'css',
                css: '.pattern'
              },
              section: {
                option: 'css',
                css: '.pattern'
              },
              datetime: {
                option: 'css',
                css: '.pattern'
              },
              title: {
                option: 'css',
                css: '.pattern'
              }
            }
          },
          headers: authorized_headers
      end
    end
    assert_response :success
  end
end
