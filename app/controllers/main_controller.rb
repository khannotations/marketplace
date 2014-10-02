class MainController < ApplicationController
  def logout
    session[:cas_user] = nil
    redirect_to :root
  end

  def templates
    render "templates/#{params[:path]}"
  end
end
