require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "generates an api key on create" do
    user = User.create(
      email: 'example@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
    assert_not_nil user.api_key
  end
end
