require "rails_helper"

RSpec.describe ProjectMailer, :type => :mailer do
  describe "all" do
    let(:expired) { ProjectMailer.expired(@project) }
    let(:contact) { ProjectMailer.contact(@project, @user) }

    before(:each) do
      @project = create(:project)
      @u1 = create(:user)
      @u2 = create(:user)
      @project.leaders << @u1 << @u2
    end

    describe "expired" do
      it "sends to the project's leaders" do
        to = expired.to
        expect(to.first).to eql @u1.email
        expect(to.second).to eql @u2.email
      end
    end

    describe "contact" do
      before(:each) do
        @user = create(:user)
      end

      it "sends to leaders" do
        to = contact.to
        expect(to.first).to eql @u1.email
        expect(to.second).to eql @u2.email
      end

      it "cc's the user" do
        expect(contact.cc.first).to eql @user.email
      end

      it "contains user's email" do
        expect(contact.body).to match @user.email
      end
    end
  end
end
