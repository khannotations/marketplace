require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do
  before(:each) do
    @current_user = create(:user)
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
      project = create(:project)
      get :show, id: project.id
      expect(response.status).to be 200
      expect(response.body).to match "\"id\":#{project.id}"
      expect(response.body).to match "\"name\":\"#{project.name}\""
    end

    it "throws error with invalid id" do
      get :show, id: -1
      expect(response.status).to be 404
      expect(response.body).to match "\"error\":"
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
      expect(project.leader_ids).to include(@current_user.id)
    end

    it "fails to create with missing parameters" do
      project = build(:project, name: "")
      post :create, project.attributes
      expect(response.status).to be 400
    end
  end

  describe "update" do
    it "forbids when user is not authorized" do
      old_name = @project.name
      @project.name = "Amazing Project Yo"
      put :update, @project.attributes
      expect(response.status).to be 403
    end

    it "updates correct attibutes when user is authorized" do
      @project.leaders << @current_user
      old_name = @project.name
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
end

