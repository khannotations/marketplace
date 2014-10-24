class SkillsController < ApplicationController
  respond_to :json
  before_filter :require_login
  before_filter :check_admin, except: :index

  def index
    render json: Skill.all
  end

  def create
    @skill = Skill.create(skill_params)
    if @skill.id
      render json: @skill
    else
      render_error "skill could not be created", 400
    end
  end

  def update
    @skill = Skill.find_by(id: params[:id])
    if @skill.update_attributes(skill_params)
      render json: @skill
    else
      render_error "skill could not be updated", 400
    end
  end

  def destroy
    Skill.find_by(id: params[:id]).destroy
    render json: {}, status: 200
  end

  protected

  def skill_params
    params.permit(:name)
  end
end
