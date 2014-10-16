class SkillLinksController < ApplicationController
  respond_to :json
  before_filter :require_login
  before_filter :check_authorization_to_context

  def create
    @skill_link = SkillLink.create(skillable: @context, skill: @skill)
    if @skill_link.id
      render json: @context
    else
      render_error "skill link could not be created", status: 400
    end
  end

  def destroy
    @skill_link = SkillLink.find_by(skillable: @context, skill: @skill)
    if @skill_link
      @skill_link.destroy
      render json: @context
    else
      render_error "this object doesn't have this skill", 404
    end
  end

  protected

  def set_context
    @context = nil
    if params[:user_id]
      @context = User.find_by(id: params[:user_id])
    elsif params[:opening_id]
      @context = Opening.find_by_id(params[:opening_id])
    end
    unless @context
      render_error "skill target not found", 404
    else
      @skill = Skill.find_by(id: params[:skill_id])
      render_error "skill not found", 404 unless @skill
    end
  end

  def check_authorization_to_context
    set_context
    if @context.class.name == "User"
      check_authorization_to_user(@context.id)
    elsif @context.class.name == "Opening"
      check_authorization_to_project(@context.project.id)
    else
      render_error "bad context", status: 400
    end
  end
end
