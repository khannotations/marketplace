class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    user = User.find_by(netid: session[:cas_user])
    if not user or not user.email
      user = User.get_info session[:cas_user]
    end
    user
  end
end
