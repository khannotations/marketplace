require "rails_helper"

RSpec.describe Project, :type => :model do
  describe "create" do
    it "requires necessary attributes" do
      expect(build(:project, name: nil)).to_not be_valid
      expect(build(:project, overview: nil)).to_not be_valid
      # Long overview
      expect(build(:project, overview: "123456790123456790123456790123456790123456790123456790123456790123456790123456790123456790123456790123456790123456790123456790123456790123456790123456790")).to_not be_valid
      expect(build(:project, project_description: nil)).to_not be_valid
      expect(build(:project, job_description: nil)).to_not be_valid
      expect(build(:project, pay_amount: nil)).to_not be_valid
      expect(build(:project, pay_type: nil)).to_not be_valid
      expect(build(:project, timeframe: nil)).to_not be_valid
    end
  end

  it_behaves_like "thoroughly searchable"

  # describe "search" do
  #   context "through skill" do
  #     before(:each) do
  #       @p1.skills << create(:skill, name: "Angular")
  #       @p2.skills << create(:skill, name: "Design")
  #     end

  #     it "finds using name" do
  #       expect(Project.search({q: "angular"})).to eq [@p1]
  #     end
  #   end
  # end

  describe "destroy" do
    
  end

  describe "expire notifications" do
    before(:each) do
      Project.delete_all
      @projects = []
      4.times do
        p = create(:project)
        p.leaders << create(:user) << create(:user)
        p.save
        @projects.push p
      end
      @projects[0].expires_on = Date.today - 2.days
      @projects[0].expire_notified = true
      @projects[1].expires_on = Date.today - 1.days
      @projects[2].expires_on = Date.today
      @projects[3].expires_on = Date.today + 1.days
      @projects.each { |p| p.save }
    end

    it "marks all expired projects as notified" do
      expect(Project.where("expires_on <= ?", Date.today).count).to be 3
      expect(Project.where(expire_notified: true).count).to be 1
      Project.notify_expired
      expect(Project.where(expire_notified: true).count).to be 3
    end

    it "sends emails only to unnotified leaders" do
      expect { Project.notify_expired }.to change {
        ActionMailer::Base.deliveries.length
      }.by 2
    end
  end
end
