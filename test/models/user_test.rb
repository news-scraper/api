require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "generates an api key on create" do
    user = User.create(email: 'example@example.com')
    assert_not_nil user.api_key
  end
end
