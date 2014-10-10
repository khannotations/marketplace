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
    # First time logging, or for some other reason didn't populate fields
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
end
