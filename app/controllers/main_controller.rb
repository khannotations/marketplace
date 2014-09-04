class MainController < ApplicationController
  def index
    @user = current_user
  end

  def logout
    session[:cas_user] = nil
    redirect_to :root
  end
end
