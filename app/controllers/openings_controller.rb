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
      {project_id: params[:project_id]}))
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
    render json: Opening.search(JSON.parse(params[:search], symbolize_names: true),
      params[:page])
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
