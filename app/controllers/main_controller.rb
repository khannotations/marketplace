class MainController < ApplicationController
  before_action CASClient::Frameworks::Rails::Filter, only: :login

  def index
    # User may be logged in or not. The front-end will handle what to show
    # by calling get_current
  end

  def login
    redirect_to :root
  end

  def logout
    session[:cas_user] = nil
    redirect_to :root
  end

  def destroy
    current_user.destroy
    session[:cas_user] = nil
    redirect_to :root
  end

  def templates
    render "templates/#{params[:path]}"
  end
end
