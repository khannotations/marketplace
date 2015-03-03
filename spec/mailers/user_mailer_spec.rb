require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  describe "digest" do
    let(:digest) { UserMailer.digest(@user) }

    before(:each) do
      @user = create(:user)
      4.times { |i| create(:project, name: "project #{i}") }
    end

    it "sends to most recent projects" do
      expect(digest.to).to eql([@user.email])
      expect(digest.body.encoded).to_not match "project 0"
      expect(digest.body.encoded).to match "project 1"
      expect(digest.body.encoded).to match "project 2"
      expect(digest.body.encoded).to match "project 3"
    end
  end
end
