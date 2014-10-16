class OpeningsController < ApplicationController
  respond_to :json
  before_filter :require_login
  before_filter :check_authorization_to_project, only: [:create, :update, :destroy]
  before_filter :set_opening, only: [:update, :destroy]

  def create
    @opening = Opening.create(opening_params.merge(
      {project_id: params[:project_id]}))
    if @opening.id
      render json: @opening
    else
      render_error "opening could not be created", 400
    end
  end

  def update
    if @opening.update_attributes(opening_params)
      render json: @opening
    else
      render_error "opening could not be updated", 400
    end
  end

  def destroy
    @opening.destroy
    render json: {}, status: 200
  end

  def search
    render json: Opening.search(params[:q], params[:page])
  end

  protected

  def set_opening
    @opening = Opening.find_by(id: params[:id])
    render_error "opening not found", 404 unless @opening
  end

  def opening_params
    params.permit(:name, :description, :timeframe, :pay_amount, :pay_type)
  end

end
