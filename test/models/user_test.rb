require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "User can be created" do
    user = User.new
    assert_not user.save, "Cannot save user with required fields missen"
  end
end
