require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do

  before(:each) do
    @current_user = create(:user, first_name: "Stan")
    session[:cas_user] = @current_user.netid # Artificially log user in
    request.env["HTTP_ACCEPT"] = 'application/json'
    @project = create(:project)
  end

  describe "show" do
    it "forbids when not logged in" do
      session[:cas_user] = nil
      get :show, id: @current_user.id
      expect(response.status).to be 403
    end

    it "gets correct project with valid id" do
      get :show, id: @project.id
      expect(response.status).to be 200
      expect(response.body).to match "\"id\":#{@project.id}"
      expect(response.body).to match "\"name\":\"#{@project.name}\""
    end

    it "throws error with invalid id" do
      get :show, id: -1
      expect(response.status).to be 404
      expect(response.body).to match "\"error\":"
    end

    it "sends back associated openings" do
      opening = create(:opening, project: @project, name: "Awesome opening")
      get :show, id: @project.id
      expect(response.status).to be 200
      expect(response.body).to match "\"id\":#{opening.id}"
      expect(response.body).to match "\"name\":\"#{opening.name}\""
    end

    it "sends back associated leaders" do
      @project.leaders << @current_user
      new_user = create(:user)
      @project.leaders << new_user
      get :show, id: @project.id
      expect(response.status).to be 200
      expect(response.body).to match "\"first_name\":\"#{@current_user.first_name}\""
      expect(response.body).to match "\"first_name\":\"#{new_user.first_name}\""
    end
  end

  describe "create" do
    before(:each) do
      @new_project = build(:project)
    end
    it "creates a project" do
      expect(Project.find_by(name: @new_project.name)).to be_nil
      post :create, @new_project.attributes
      expect(response.status).to be 201
      expect(response.body).to match "\"name\":\"#{@new_project.name}\""
      expect(Project.find_by(name: @new_project.name)).to_not be_nil
    end

    it "adds current user as a leader" do
      post :create, @new_project.attributes
      project = Project.includes(:leaders).find_by(name: @new_project.name)
      expect(project).to_not be_nil
      expect(project.leader_ids).to include(@current_user.id)
    end

    it "fails to create with missing parameters" do
      project = build(:project, name: "")
      post :create, project.attributes
      expect(response.status).to be 400
    end

    it "starts unapproved, and sends an email" do
      post :create, @new_project.attributes
      expect(Project.find_by(name: @new_project.name).approved).to_be false
    end
  end

  describe "update" do
    it "forbids when user is not authorized" do
      old_name = @project.name
      @project.name = "Amazing Project Yo"
      put :update, @project.attributes
      expect(response.status).to be 403
      expect(Project.find(@project.id).name).to eql(old_name)
    end

    it "updates correct attibutes when user is authorized" do
      @project.leaders << @current_user
      @project.name = "Amazing Project Yo"
      put :update, @project.attributes
      expect(response.status).to be 200
      expect(response.body).to match "\"name\":\"Amazing Project Yo\""
    end

    it "allows admins to update" do
      @current_user.is_admin = true
      @current_user.save
      @project.name = "Amazing Project Yo"
      put :update, @project.attributes
      expect(response.status).to be 200
      expect(response.body).to match "\"name\":\"Amazing Project Yo\""
    end
  end

  describe "destroy" do
    it "forbids when user is not authorized" do
      delete :destroy, @project.attributes
      expect(response.status).to be 403
      expect(Project.find_by(id: @project.id)).to_not be_nil
    end

    it "destroys when user is authorized" do
      @project.leaders << @current_user
      delete :destroy, @project.attributes
      expect(response.status).to be 200
      expect(Project.find_by(id: @project.id)).to be_nil
    end
  end
end

