require "rails_helper"

RSpec.describe Project, :type => :model do
  it "requires necessary attributes" do
      expect(build(:project, name: nil)).to_not be_valid
      expect(build(:project, description: nil)).to_not be_valid
    end

  it_behaves_like "thoroughly searchable"
end