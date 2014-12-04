class OpeningsController < ApplicationController
  respond_to :json
  before_filter :require_login
  before_filter :check_authorization_to_project, only: [:create, :update, :destroy]
  before_filter :set_opening, only: [:show, :update, :destroy]

  def show
    render json: @opening
  end

  def create
    @opening = Opening.create(opening_params.merge(
      {project_id: params[:project_id], expires_on: Date.today + 1.month}))
    if @opening.id
      if params[:skills].kind_of?(Array)
        skill_ids = params[:skills].map{ |s| s[:id] } # Get ids
        @opening.skill_ids = skill_ids.compact.uniq   # Remove nils and dups
        @opening.save
      end
      render json: @opening
    else
      render_error "opening could not be created", 400
    end
  end

  def update
    if @opening.update_attributes(opening_params)
      if params[:skills].kind_of?(Array)
        skill_ids = params[:skills].map{ |s| s[:id] } # Get ids
        @opening.skill_ids = skill_ids.compact        # Remove nils
        @opening.save
      end
      render json: @opening
    else
      render_error "opening could not be updated", 400
    end
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
    params.permit(:name, :description, :timeframe, :pay_amount, :pay_type, :skills)
  end

end
