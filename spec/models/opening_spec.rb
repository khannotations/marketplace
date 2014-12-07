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
      @o1.project = create(:project, name: "Economics project", approved: true)
      @o1.save
      @o2.project = create(:project,
        description: "A exciting project in brain psychology", approved: true)
      @o2.save
    end

    it_behaves_like "thoroughly searchable"

    context "through project" do
      it "finds through project name" do
        expect(Project.thorough_search("economics")).to eq [@o1.project]
        expect(Opening.search({q: "economics"})).to eq [@o1]
      end

      it "finds through project description (inclusive)" do
        expect(Opening.search({q: "psychology"})).to eq [@o2]
        expect(Opening.search({q: "brain psychology"})).to eq [@o2]
        expect(Opening.search({q: "child psychology"})).to eq [@o2]
      end

      it "does close search on project" do
        expect(Opening.search({q: "psychologic"})).to eq [@o2]
      end
    end

    context "through skill" do
      before(:each) do
        @o1.skills << create(:skill, name: "Angular")
        @o2.skills << create(:skill, name: "Design")
      end

      it "finds using name" do
        expect(Opening.search({q: "angular"})).to eq [@o1]
      end
    end
  end 

  describe "expire notifications" do
    before(:each) do
      Opening.delete_all
      @openings = []
      4.times do
        o = create(:opening)
        o.project = create(:project)
        o.project.leaders << create(:user) << create(:user)
        o.save
        @openings.push o
      end
      @openings[0].expires_on = Date.today - 2.days
      @openings[0].expire_notified = true
      @openings[1].expires_on = Date.today - 1.days
      @openings[2].expires_on = Date.today
      @openings[3].expires_on = Date.today + 1.days
      @openings.each { |o| o.save }
    end

    it "markes all expired openings as notified" do
      expect(Opening.where("expires_on <= ?", Date.today).count).to be 3
      expect(Opening.where(expire_notified: true).count).to be 1
      Opening.notify_expired
      expect(Opening.where(expire_notified: true).count).to be 3
    end

    it "sends emails only to unnotified leaders" do
      expect { Opening.notify_expired }.to change {
        ActionMailer::Base.deliveries.length
      }.by 2
    end
  end
end
