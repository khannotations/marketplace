class ProjectsController < ApplicationController
  respond_to :json

  before_filter :require_login
  before_filter :check_authorization_to_project, only: [:update, :destroy]
  before_filter :set_project, only: [:show]

  def show
    render json: @project
  end

  def create
    @project = Project.create(project_params)
    if @project.id
      @project.leaders << current_user
      respond_with @project
    else
      render_error "project could not be created", 400
    end
  end

  def update
    if @project.update_attributes(project_params)
      render json: @project
    else
      render_error "project could not be updated", 400
    end
  end

  def destroy
    @project.destroy # Destroys all associated openings
    render json: {}, status: 200
  end

  protected

  def set_project
    @project = Project.includes(:leaders, :openings).find_by(id: params[:id])
    render_error "project not found", 404 unless @project
  end

  def project_params
    params.permit(:name, :description)
  end
end
