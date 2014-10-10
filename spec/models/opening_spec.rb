require "rails_helper"

RSpec.describe Opening, :type => :model do
  describe "validations" do
    it "requires necessary attributes" do
      expect(build(:opening, name: nil)).to_not be_valid
      expect(build(:opening, description: nil)).to_not be_valid
      expect(build(:opening, pay_amount: nil)).to_not be_valid
      expect(build(:opening, pay_type: nil)).to_not be_valid
      expect(build(:opening, timeframe: nil)).to_not be_valid
    end
  end

  describe "search" do
    before(:each) do
      @o1 = create(:opening)
      @o2 = create(:opening)
    end

    it_behaves_like "thoroughly searchable"

    context "through project" do
      before (:each) do
        @o1.project = create(:project, name: "Economics project")
        @o1.save
        @o2.project = create(:project,
          description: "A exciting project in brain psychology")
        @o2.save
      end
      it "finds through project name" do
        expect(Project.thorough_search("economics")).to eq [@o1.project]
        expect(Opening.search("economics")).to eq [@o1]
      end

      it "finds through project description (inclusive)" do
        expect(Opening.search("psychology")).to eq [@o2]
        expect(Opening.search("brain psychology")).to eq [@o2]
        expect(Opening.search("child psychology")).to eq [@o2]
      end

      it "does close search on project" do
        expect(Opening.search("psychologic")).to eq [@o2]
      end
    end

    context "through skill" do
      before(:each) do
        @o1.skills << create(:skill, name: "Angular")
        @o2.skills << create(:skill, name: "Design")
      end

      it "finds using name" do
        expect(Opening.search("angular")).to eq [@o1]
      end
    end

  end 
end