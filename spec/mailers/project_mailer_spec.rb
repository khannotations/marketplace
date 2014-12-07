require "rails_helper"

RSpec.describe ProjectMailer, :type => :mailer do
  describe "expire opening" do
    let(:expired_opening) { ProjectMailer.expired_opening(@opening) }

    before(:each) do
      @opening = create(:opening)
      @u1 = create(:user)
      @u2 = create(:user)
      @opening.project = create(:project)
      @opening.project.leaders << @u1 << @u2
    end

    it "sends to the opening's project leaders" do
      to = expired_opening.to
      expect(to.first).to eql @u1.email
      expect(to.second).to eql @u2.email
    end
  end
end
