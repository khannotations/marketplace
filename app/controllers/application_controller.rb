class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Convenience method that gets the current user (with all fields populated)
  #   or returns nil if the user is not logged in
  def current_user
    return nil unless user_logged_in?
    return @user if @user # Avoid database lookup if already defined
    @user = User.find_by(netid: session[:cas_user])
    # First time logging in, or for some other reason didn't populate fields
    if not @user or not @user.email
      @user = User.get_info session[:cas_user]
    end
    @user
  end

  # Before filter
  def require_login
    render_error("You must be logged in to do that", 403) unless user_logged_in?
  end

  # Convenience method
  def user_logged_in?
    return !!session[:cas_user]
  end

  def render_error(msg="", status=400) 
    render json: {error: msg}, status: status
  end

  def check_admin
    render_error "access forbidden", 403 unless current_user.is_admin
  end

  def check_authorization_to_project(project_id=nil)
    id = project_id || params[:project_id] || params[:id]
    @project = Project.find_by(id: id)
    render_error "project not found", 404 unless @project
    @user = current_user
    unless @project.leader_ids.include? @user.id or @user.is_admin
      render_error "access forbidden", 403
    end
  end

  # This method assumes user_logged_in? is true
  def check_authorization_to_user(user_netid=nil)
    netid = user_netid || params[:id]
    @user = current_user
    unless @user.netid == netid or @user.is_admin
      render_error "access forbidden", 403
    end
  end
end
