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
      @p = create(:project)
      @u = create(:user)
      @s = create(:skill)
      @s.users << @u 
      @s.projects << @p
    end

    it "gets projects" do
      expect(@s.projects).to eq [@p]
    end

    it "gets users" do
      expect(@s.users).to eq [@u]
    end
  end

  context "search" do
    before(:each) do
      @p = create(:project, name: "Ruby on Rails", approved: true)
    end

    it "finds by exact name" do
      expect(Project.search({q: "ruby on rails"})).to eq [@p]
    end

    it "finds by part of name" do
      expect(Project.search({q: "ruby"})).to eq [@p]
      expect(Project.search({q: "rails"})).to eq [@p]
    end

    it "misses when wrong name" do
      expect(Project.search({q: "iOS"})).to eq []
    end
  end
end
