class TemplatesController < ApplicationController
  def public
    render "templates/#{params[:path]}"
  end
end
