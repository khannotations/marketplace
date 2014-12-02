class ProjectsController < ApplicationController
  respond_to :json

  before_filter :require_login
  before_filter :check_admin, only: :approve
  # Sets project
  before_filter :check_authorization_to_project, only: [:update, :destroy]
  before_filter :set_project, only: [:show, :approve]

  def show
    render json: @project, include: [:leaders, :openings]
  end

  def create
    @project = Project.create(project_params)
    if @project.id
      @project.leaders << current_user
      render json: @project, include: [:leaders, :openings]
    else
      render_error "project could not be created", 400
    end
  end

  def update
    if @project.update_attributes(project_params)
      render json: @project, include: [:leaders, :openings]
    else
      render_error "project could not be updated", 400
    end
  end

  def destroy
    @project.destroy # Destroys all associated openings
    render json: {}, status: 200
  end

  def approve
    @project.approved = true;
    if @project.save
      render json: @project
    else
      render_error "project could not be approved", 400
    end
  end

  def unapproved
    render json: Project.where(approved: false)
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
