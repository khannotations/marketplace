class UsersController < ApplicationController
  respond_to :json
  # Since AJAX doesn't work well with the CAS filter, we check for authorization
  # and authentication manually
  before_filter :require_login, except: [:current]
  before_filter :check_authorization_to_user, except: [:current, :show]
  before_filter :set_user, only: [:show, :update]

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
    respond_with @user
  end

  def update
    # respond_with in PUT behaves unexpectedly, so using render instead
    if @user.update_attributes(user_params)
      render json: @user
    else
      render_error "user couldn't be updated", 400
    end
  end

  def search
    render json: "" # User.search(params[:q], params[:page])
  end

  protected

  def user_params
    params.permit(:first_name, :bio, :github_url, :linkedin_url)
  end

  def set_user
    @user = User.find_by(id: params[:id])
    render_error "user not found", 404 unless @user
  end
end
