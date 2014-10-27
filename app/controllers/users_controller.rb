class UsersController < ApplicationController
  respond_to :json
  # Since AJAX doesn't work well with the CAS filter, we check for authorization
  # and authentication manually
  before_filter :require_login, except: [:current]
  before_filter :check_authorization_to_user, only: [:update]

  # Get current user
  def current
    @user = current_user
    if @user
      respond_with @user
    else
      render json: ""
    end
  end

  def show
    @user = User.includes(:skills, :leading_projects)
      .find_by(netid: params[:id])
    if @user
      render json: @user, include: [:skills, :leading_projects]
    else
      render_error "user not found", 404
    end
  end

  def update
    @user = User.find_by(netid: params[:id]) # The :id key is set by Rails as default
    unless @user
      render_error "user not found", 404
    else
      # respond_with in PUT behaves unexpectedly, so using render instead
      if @user.update_attributes(user_params)
        if params[:skills].kind_of?(Array)
          skill_ids = params[:skills].map{ |s| s[:id] } # Get ids
          @user.skill_ids = skill_ids.compact.uniq      # Remove nils
          @user.save
        end
        render json: @user
      else
        render_error "user couldn't be updated", 400
      end
    end
  end

  def search
    render json: User.search(JSON.parse(params[:search], symbolize_names: true),
      params[:page]), include: :skills
  end

  protected

  def user_params
    params.permit(:first_name, :bio, :github_url, :linkedin_url)
  end
end
