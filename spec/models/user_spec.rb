require "rails_helper"

RSpec.describe User, :type => :model do
  it "doesn't save without netid" do
    user = build(:user, netid: nil)
    expect(user.save).to be false
  end

  it "doesn't save without email" do
    user = build(:user, email: nil)
    expect(user.save).to be false
  end
end