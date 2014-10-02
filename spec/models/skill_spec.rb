require "rails_helper"

RSpec.describe Skill, :type => :model do
  it "requires name" do
    expect(build(:skill, name: nil)).to_not be_valid
  end

  it "requires unique name" do
    name = "Cool skill"
    create(:skill, name: name)
    expect(build(:skill, name: name)).to_not be_valid
  end

  context "openings" do
    before(:each) do
      @o = create(:opening)
      @u = create(:user)
      @s = create(:skill)
      @s.users << @u 
      @s.openings << @o
    end

    it "gets openings" do
      expect(@s.openings.to_a).to eq [@o]
    end

    it "gets users" do
      expect(@s.users.to_a).to eq [@u]
    end
  end
end