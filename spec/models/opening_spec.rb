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
      @js_dev = create(:opening,
        name: "Javascript Developer",
        description: "Looking to hire fast-paced, experienced coder."
      )
      @ios_dev = create(:opening,
        name: "iOS Developer",
        description: "A great design sense, experience with Swift."
      )
    end

    context "opening only" do
      it "finds when word is in name" do
        expect(Opening.search("iOS")).to eq [@ios_dev]
      end

      it "finds when word is in description" do
        expect(Opening.search("Swift")).to eq [@ios_dev]
      end

      it "is case insensitive" do
        expect(Opening.search("swIfT")).to eq [@ios_dev]
      end

      xit "finds description by loose terms" do
        expect(Opening.search("experience")).to eq [@js_dev, @ios_dev]
      end

      it "finds containing any with multiple words" do
        expect(Opening.search("Javascript Swift")).to eq [@js_dev, @ios_dev]
      end
    end

    context "through project" do
      xit "finds through project name"
    end

    context "through skill" do
      before(:each) do
        @js_dev.skills << create(:skill, name: "Angular")
        @ios_dev.skills << create(:skill, name: "Design")
      end
      it "finds using name" do
        expect(Opening.search("angular")).to eq [@js_dev]
      end
    end

  end 
end