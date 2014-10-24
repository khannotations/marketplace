require 'rails_helper'

RSpec.describe SkillsController, :type => :controller do
  before (:each) do
    @current_user = create(:user)
    session[:cas_user] = @current_user.netid # Artificially log user in
    request.env["HTTP_ACCEPT"] = 'application/json'
    @skill = create(:skill)
  end

  describe "index" do
    it "fails when not logged in" do
      session[:cas_user] = nil
      get :index
      expect(response.status).to be 403
    end
    it "gets when logged in" do
      get :index
      expect(response.status).to be 200
      expect(response.body).to match "\"name\":\"#{@skill.name}\""
    end
  end

  describe "create" do
    it "forbids when user isn't admin" do
      skill = build(:skill)
      post :create, skill.attributes
      expect(response.status).to be 403
    end

    it "fails when no name" do
      skill = build(:skill, name: "")
      @current_user.is_admin = true
      @current_user.save
      post :create, skill.attributes
      expect(response.status).to be 400
    end

    it "works with right params" do
      skill = build(:skill)
      @current_user.is_admin = true
      @current_user.save
      post :create, skill.attributes
      expect(response.status).to be 200
      expect(response.body).to match "\"name\":\"#{skill.name}\""
    end
  end

  describe "update" do
    it "works" do
      @skill.name = "Skydiving"
      @current_user.is_admin = true
      @current_user.save
      put :update, @skill.attributes
      expect(response.status).to be 200
      expect(response.body).to match "\"name\":\"Skydiving\""
    end
  end

  describe "destroy" do
    it "works" do
      @current_user.is_admin = true
      @current_user.save
      expect(Skill.find_by(id: @skill.id)).to_not be_nil
      delete :destroy, {id: @skill.id}
      expect(response.status).to be 200
      expect(response.body).to eql "{}"
      expect(Skill.find_by(id: @skill.id)).to be_nil
    end
  end
end
