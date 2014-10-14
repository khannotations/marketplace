require 'rails_helper'

RSpec.describe SkillLinksController, :type => :controller do
  before(:each) do
    @opening = create(:opening)
    @user = create(:user)
    @skill = create(:skill)
    session[:cas_user] = @user.netid # login user
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe "create" do
    it "works with user" do
      expect(SkillLink.find_by(skillable: @user, skill: @skill)).to be_nil
      post :create, user_id: @user.id, skill_id: @skill.id
      expect(response.status).to eql 200
      expect(SkillLink.find_by(skillable: @user, skill: @skill)).to_not be_nil
    end

    it "works with opening" do
      @opening.project.leaders << @user
      @opening.project.save
      expect(SkillLink.find_by(skillable: @opening, skill: @skill)).to be_nil
      post :create, opening_id: @opening.id, skill_id: @skill.id
      expect(response.status).to eql 200
      expect(SkillLink.find_by(skillable: @opening, skill: @skill)).to_not be_nil
    end
  end

  describe "destroy" do
    it "works with user" do
      skill_link = create(:skill_link, skillable: @user, skill: @skill)
      expect(SkillLink.find_by(skillable: @user, skill: @skill)).to_not be_nil
      post :destroy, user_id: @user.id, skill_id: @skill.id
      expect(response.status).to eql 200
      expect(response.body).to match("\"first_name\":\"#{@user.first_name}\"")
      expect(SkillLink.find_by(skillable: @user, skill: @skill)).to be_nil
    end

    it "works with opening" do
      @opening.project.leaders << @user
      @opening.project.save
      skill_link = create(:skill_link, skillable: @opening, skill: @skill)
      expect(SkillLink.find_by(skillable: @opening, skill: @skill)).to_not be_nil
      post :create, opening_id: @opening.id, skill_id: @skill.id
      expect(response.status).to eql 200
      expect(response.body).to match("\"name\":\"#{@opening.name}\"")
      expect(SkillLink.find_by(skillable: @opening, skill: @skill)).to be_nil
    end
  end
end
