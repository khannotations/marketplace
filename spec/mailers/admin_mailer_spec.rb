require "rails_helper"

RSpec.describe AdminMailer, :type => :mailer do
  before(:each) do
    @project = create(:project)
    @m = mail
  end
  let(:mail) { AdminMailer.project_approval(@project) }

  describe "Project approval" do
    it "sends to admin" do
      admin = User.find_by(is_admin: true)
      expect(@m.to).to match(admin.full_name)
      expect(@m.to).to match(admin.email)
    end
    it "assigns project" do
      expect(@m.body.encoded).to match(@project.name)
      expect(@m.body.encoded).to match(@project.id.to_s)
    end
  end
end
