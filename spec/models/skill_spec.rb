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

  context "skillables" do
    before(:each) do
      @o = create(:opening)
      @u = create(:user)
      @s = create(:skill)
      @s.users << @u 
      @s.openings << @o
    end

    it "gets openings" do
      expect(@s.openings).to eq [@o]
    end

    it "gets users" do
      expect(@s.users).to eq [@u]
    end
  end

  context "search" do
    before(:each) do
      @o = create(:opening, name: "Ruby on Rails")
    end

    it "finds by exact name" do
      expect(Opening.search("ruby on rails")).to eq [@o]
    end

    it "finds by part of name" do
      expect(Opening.search("ruby")).to eq [@o]
      expect(Opening.search("rails")).to eq [@o]
    end

    it "misses when wrong name" do
      expect(Opening.search("iOS")).to eq []
    end
  end
end
