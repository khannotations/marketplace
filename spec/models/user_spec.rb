require "rails_helper"

RSpec.describe User, :type => :model do
  it "requires netid" do
    expect(build(:user, netid: nil)).to_not be_valid
  end

  it "requires email" do
    expect(build(:user, email: nil)).to_not be_valid
  end
end