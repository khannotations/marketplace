require 'test_helper'
 
class UserTest < ActiveSupport::TestCase
  test "doesn't save without netid" do
    user = build(:user, netid: nil)
    assert_not user.save
  end

  test "doesn't save without email" do
    user = build(:user, email: nil)
    assert_not user.save
  end
end