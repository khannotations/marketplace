require "rails_helper"

RSpec.describe ProjectMailer, :type => :mailer do
  describe "expire opening" do
    let(:expired_opening) { ProjectMailer.expired_opening(@opening) }
    let(:opening_contact) { ProjectMailer.opening_contact(@opening, @user) }

    before(:each) do
      @opening = create(:opening)
      @u1 = create(:user)
      @u2 = create(:user)
      @opening.project = create(:project)
      @opening.project.leaders << @u1 << @u2
    end

    describe "expired_opening" do
      it "sends to the opening's project leaders" do
        to = expired_opening.to
        expect(to.first).to eql @u1.email
        expect(to.second).to eql @u2.email
      end
    end

    describe "opening contact" do
      before(:each) do
        @user = create(:user)
      end

      it "sends to opening's project leaders" do
        to = opening_contact.to
        expect(to.first).to eql @u1.email
        expect(to.second).to eql @u2.email
      end

      it "cc's the user" do
        expect(opening_contact.cc.first).to eql @user.email
      end

      it "contains user's email" do
        expect(opening_contact.body).to match @user.email
      end
    end
  end
end
