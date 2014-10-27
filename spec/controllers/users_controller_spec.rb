require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  before(:each) do
    @current_user = create(:user)
    session[:cas_user] = @current_user.netid # Artificially log user in
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe "current user" do
    it "gets when logged in" do
      get :current
      expect(response.status).to be 200
      expect(response.body).to match "\"netid\":\"#{@current_user.netid}\""
    end

    it "returns nil when not logged in" do
      session[:cas_user] = nil
      get :current
      expect(response.status).to be 200
      expect(response.body).to eql ""
    end
  end

  describe "show [profile]" do
    it "forbids when not logged in" do
      session[:cas_user] = nil
      get :show, id: @current_user.netid
      expect(response.status).to be 403
    end

    it "gets correct user with valid id" do
      user = create(:user)
      get :show, id: user.netid
      expect(response.status).to be 200
      expect(response.body).to match "\"netid\":\"#{user.netid}\""
      expect(response.body).to_not match "\"netid\":\"not the user netid\""
    end

    it "throws error with invalid netid" do
      get :show, id: "somethingthat'snotanetid"
      expect(response.status).to be 404
      expect(response.body).to match "\"error\":"
    end
  end

  describe "update" do
    it "forbids when user is not authorized" do
      user = create(:user)
      old_first_name = user.first_name
      user.first_name = "Rafi++"
      put :update, user.attributes.merge({id: user.netid})
      expect(response.status).to be 403
    end

    it "updates correct attibutes when user is authorized" do
      old_email = @current_user.email
      old_last_name = @current_user.last_name
      @current_user.first_name = "MechaStan"
      @current_user.email = "stn1337@yalemail.com"
      @current_user.last_name = "TheMan"
      put :update, @current_user.attributes.merge({id: @current_user.netid})
      expect(response.status).to be 200
      expect(response.body).to match "\"first_name\":\"MechaStan\""
      expect(response.body).to match "\"email\":\"#{old_email}\""
      expect(response.body).to match "\"last_name\":\"#{old_last_name}\""
    end

    it "updates with skills" do
      skill1 = create(:skill)
      @current_user.skills << skill1
      expect(User.find(@current_user.id).skills).to eq [skill1]
      skill2 = create(:skill)
      skill3 = create(:skill)
      put :update, @current_user.attributes.merge({id: @current_user.netid,
        skills: [skill2.attributes, skill3.attributes]})
      expect(response.status).to be 200
      # After, has new skills, not old one
      expect(User.find(@current_user.id).skills).to eq [skill2, skill3]
    end

    it "allows admins to update" do
      @current_user.is_admin = true
      @current_user.save
      user = create(:user)
      old_first_name = user.first_name
      user.first_name = "RobotRafi"
      put :update, user.attributes.merge({id: user.netid})
      expect(response.status).to be 200
      expect(response.body).to match "RobotRafi"
    end
  end

  describe "search" do
    before(:each) do
      p = {q: @current_user.first_name}
      @search_params = {search: p.to_json} # JSON params are strings
    end

    it "forbids unless logged in" do
      session[:cas_user] = nil
      get :search, @search_params
      expect(response.status).to be 403
    end

    it "works" do
      get :search, @search_params
      expect(response.status).to be 200
      expect(response.body).to match /\[.*\]/
      expect(response.body).to match "\"id\":#{@current_user.id}"
    end
  end
end

