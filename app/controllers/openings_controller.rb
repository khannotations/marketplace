class OpeningsController < ApplicationController
  respond_to :json
  before_filter :require_login, except: :search
  before_filter :check_authorization_to_project, only:
    [:create, :update,  :renew, :destroy]
  before_filter :set_opening, only: [:show, :update, :renew, :destroy]

  def show
    render json: @opening
  end

  def create
    @opening = Opening.create(opening_params.merge(
      {project_id: params[:project_id]}))
    if @opening.id
      if params[:skills].kind_of?(Array)
        skill_ids = params[:skills].map{ |s| s[:id] } # Get ids
        @opening.skill_ids = skill_ids.compact.uniq   # Remove nils and dups
        @opening.save
      end
      render json: @opening
    else
      render_error "You opening could not be created." + 
        " Please make sure you've filled out all the fields", 400
    end
  end

  def update
    if @opening.update_attributes(opening_params)
      if params[:skills].kind_of?(Array)
        skill_ids = params[:skills].map{ |s| s[:id] } # Get ids
        @opening.skill_ids = skill_ids.compact        # Remove nils
        @opening.save
      end
      if params[:leaders] && params[:leaders].kind_of(Array)
        leader_ids = params[:leaders].map { |l| l[:id]}
        @opening.leader_ids = (leader_ids << current_user.id).compact
        @opening.save
      end
      render json: @opening
    else
      render_error "opening could not be updated", 400
    end
  end

  def renew
    @opening.expires_on = Date.today + 1.month
    @opening.expire_notified = false
    @opening.save
    render json: @opening
  end

  def destroy
    @opening.destroy # Destroys associated skill_links
    render json: {}, status: 200
  end

  def search
    if (params[:search])
      search_params = JSON.parse(params[:search], symbolize_names: true)
    end
    if (params[:search] && search_params[:q] != "")
      @openings = Opening.search(search_params, params[:page])
    else
      @openings = Opening.all
    end
    render json: @openings
  end

  protected

  def set_opening
    @opening = Opening.find_by(id: params[:id])
    render_error "opening not found", 404 unless @opening
  end

  def opening_params
    params.permit(:name, :description, :timeframe, :pay_amount, :pay_type,
      :skills, :filled)
  end

end
