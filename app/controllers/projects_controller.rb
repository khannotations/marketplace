class ProjectsController < ApplicationController
  respond_to :json

  before_filter :require_login, except: :search
  before_filter :check_admin, only: [:approve, :unapproved]
  # check_authorization_to_project calls set_project
  before_filter :check_authorization_to_project, only: [:update, :renew, :destroy]
  before_filter :set_project, only: [:show, :contact, :approve]

  def show
    render json: @project, include: [:leaders, :skills]
  end

  def create
    @project = Project.create(project_params)
    if @project.id
      @project.leaders << current_user
      if params[:skills].kind_of?(Array)
        skill_ids = params[:skills].map{ |s| s[:id] } # Get ids
        @project.skill_ids = skill_ids.compact.uniq   # Remove nils and dups
      end
      @project.save
      render json: @project, include: [:leaders]
      AdminMailer.project_approval(@project).deliver
      ProjectMailer.created(@project).deliver
    else
      render_error "Your posting could not be created. " +
        @project.error_string, 400
    end
  end

  def update
    if @project.update_attributes(project_params)
      if params[:skills].kind_of?(Array)
        skill_ids = params[:skills].map{ |s| s[:id] } # Get ids
        @project.skill_ids = skill_ids.compact.uniq   # Remove nils and dups
      end
      if params[:leaders].kind_of?(Array)
        leader_ids = params[:leaders].map{ |l| l[:id] } # Get ids
        @project.leader_ids = leader_ids.compact.uniq   # Remove nils and dups
      end
      render json: @project, include: [:leaders]
    else
      render_error "Your posting could not be updated. " + 
        @project.error_string, 400
    end
  end

  def renew
    @project.expires_on = Date.today + 1.month
    @project.expire_notified = false
    @project.save
    render json: @project
  end

  def destroy
    @project.destroy
    render json: {}, status: 200
  end

  def approve
    @project.approved = true;
    if @project.save
      render json: @project
    else
      render_error "Project could not be approved. "+ @project.error_string, 400
    end
  end

  def unapproved
    render json: Project.where(approved: false)
  end

  def search
    if (params[:search])
      search_params = JSON.parse(params[:search], symbolize_names: true)
    end
    if (params[:search] && search_params[:q] != "")
      @projects = Project.search(search_params, params[:page])
    else
      @projects = Project.search_filtered(Project.all)
    end
    render json: @projects
  end

  def contact
    begin
      ProjectMailer.contact(@project, current_user).deliver!
      render json: @project
    rescue
      render_error "Leaders could not be contacted, please try again later.", 500
    end
  end

  protected

  def set_project
    id = params[:id] || params[:project_id]
    @project = Project.includes(:leaders).find_by(id: id)
    render_error "The project could not be found.", 404 unless @project
  end

  def project_params
    params.permit(:name, :description, :timeframe, :pay_amount, :pay_type,
      :skills, :filled)
  end
end
