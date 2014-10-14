require 'rails_helper'

RSpec.describe OpeningsController, :type => :controller do

  before(:each) do
    @current_user = create(:user)
    session[:cas_user] = @current_user.netid # Artificially log user in
    request.env["HTTP_ACCEPT"] = 'application/json'
    @project = create(:project)
    @opening = create(:opening, project: @project)
  end

  describe "create" do
    before(:each) do
      @new_opening = build(:opening, project: @project)
    end

    it "creates an opening" do
      @project.leaders << @current_user
      expect(Opening.find_by(name: @new_opening.name)).to be_nil
      post :create, @new_opening.attributes
      expect(response.status).to be 200
      expect(response.body).to match "\"name\":\"#{@new_opening.name}\""
      expect(Opening.find_by(name: @new_opening.name)).to_not be_nil
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
      old_name = @opening.name
      @opening.name = "Amazing Opening Yo"
      put :update, @opening.attributes
      expect(response.status).to be 200
      expect(response.body).to match "\"name\":\"Amazing Opening Yo\""
    end

    it "allows admins to update" do
      @current_user.is_admin = true
      @current_user.save
      @opening.name = "Amazing Opening Yo"
      put :update, @opening.attributes
      expect(response.status).to be 200
      expect(response.body).to match "\"name\":\"Amazing Opening Yo\""
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
end
