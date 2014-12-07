require 'rails_helper'

RSpec.describe OpeningsController, :type => :controller do

  before(:each) do
    @current_user = create(:user)
    session[:cas_user] = @current_user.netid # Artificially log user in
    request.env["HTTP_ACCEPT"] = 'application/json'
    @project = create(:project)
    @opening = create(:opening, project: @project)
    @skill = create(:skill)
    @opening.skills << @skill
  end

  describe "get" do
    it "gets an opening" do
      get :show, id: @opening.id
      expect(response.status).to be 200
      expect(response.body).to match "\"id\":#{@opening.id}"
    end
  end

  describe "create" do
    before(:each) do
      @new_opening = build(:opening, project: @project)
    end

    it "works" do
      @project.leaders << @current_user
      expect(Opening.find_by(name: @new_opening.name)).to be_nil
      post :create, @new_opening.attributes
      expect(response.status).to be 200
      expect(response.body).to match "\"name\":\"#{@new_opening.name}\""
      expect(Opening.find_by(name: @new_opening.name)).to_not be_nil
    end

    it "adds skills" do
      @project.leaders << @current_user
      skill = create(:skill)
      @new_opening.skills << skill
      post :create, @new_opening.attributes.merge({skills: [skill.attributes]})
      expect(response.status).to be 200
      expect(Opening.last.skills).to eq [skill]
    end

    it "sets expires on to 1 month in advance" do
      @project.leaders << @current_user
      num_openings = Opening.count
      post :create, @new_opening.attributes
      expect(response.status).to be 200
      expect(Opening.count).to be num_openings + 1
      expect(Opening.last.expires_on).to eq (Date.today + 1.month)
    end

    it "fails with missing parameters" do
      @project.leaders << @current_user
      opening = build(:opening, name: "", project: @project)
      post :create, opening.attributes
      expect(response.status).to be 400
    end

    it "forbids when user isn't authorized" do
      opening = build(:opening)
      post :create, opening.attributes
      expect(response.status).to be 403
    end
  end

  describe "update" do
    it "forbids when user is not authorized" do
      old_name = @opening.name
      @opening.name = "Amazing Opening Yo"
      put :update, @opening.attributes
      expect(response.status).to be 403
      expect(Opening.find(@opening.id).name).to eql(old_name)
    end

    it "updates correct attibutes when user is authorized" do
      @project.leaders << @current_user
      expect(@opening.filled).to be false
      @opening.name = "Amazing Opening Yo"
      @opening.filled = true
      put :update, @opening.attributes
      expect(response.status).to be 200
      expect(response.body).to match "\"name\":\"Amazing Opening Yo\""
      expect(response.body).to match "\"filled\":true"
    end

    it "allows admins to update" do
      @current_user.is_admin = true
      @current_user.save
      @opening.name = "Amazing Opening Yo"
      put :update, @opening.attributes
      expect(response.status).to be 200
      expect(response.body).to match "\"name\":\"Amazing Opening Yo\""
    end

    it "also updates skills" do
      @project.leaders << @current_user
      # At beginning, starts with the given skill
      expect(Opening.find_by(id: @opening.id).skills).to eq [@skill]
      skill = create(:skill)
      put :update, @opening.attributes.merge({skills: [skill.attributes]})
      expect(response.status).to be 200
      # After, has new skill
      expect(Opening.find_by(id: @opening.id).skills).to eq [skill]
    end
  end

  describe "destroy" do
    it "forbids when user is not authorized" do
      delete :destroy, @opening.attributes
      expect(response.status).to be 403
      expect(Opening.find_by(id: @opening.id)).to_not be_nil
    end

    it "destroys when user is authorized" do
      @project.leaders << @current_user
      delete :destroy, @opening.attributes
      expect(response.status).to be 200
      expect(Opening.find_by(id: @opening.id)).to be_nil
    end
  end

  describe "search" do
    before(:each) do
      p = {q: @opening.name}
      @search_params = {search: p.to_json} # JSON params are strings
    end

    it "works even when not logged in" do
      session[:cas_user] = nil
      get :search, @search_params
      expect(response.status).to be 200
    end

    it "works when project is approved" do
      @opening.project.approved = true
      @opening.project.save!
      get :search, @search_params
      expect(response.status).to be 200
      expect(response.body).to match /\[.*\]/
      expect(response.body).to match "\"id\":#{@opening.id}"
    end

    it "fails when project is not approved" do
      get :search, @search_params
      expect(response.status).to be 200
      expect(response.body).to match /\[\]/
    end

    it "returns all with out a search param" do
      3.times { create(:opening) }
      @search_params = {}
      get :search, @search_params
      expect(assigns[:openings].length).to be 4
    end

    it "returns all with a blank search param" do
      3.times { create(:opening) }
      @search_params = {search: {q: ""}.to_json}
      get :search, @search_params
      expect(assigns[:openings].length).to be 4
    end
  end

  describe "renew" do
    it "fails when not authorized" do
      put :renew, @opening.attributes
      expect(response.status).to be 403
    end

    it "renews by 1 month" do
      @project.leaders << @current_user
      @opening.expires_on = Date.today
      @opening.save
      put :renew, @opening.attributes
      expect(Opening.find(@opening.id).expires_on).to eql Date.today + 1.month
      expect(Opening.find(@opening.id).expire_notified).to eql false
    end
  end
end
