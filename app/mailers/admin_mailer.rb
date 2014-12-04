class AdminMailer < ActionMailer::Base
  default from: "hello@yaleprojectsboard.com"

  default to: Proc.new {
    admins = User.where(is_admin: true)
    from_names = ""
    admins.each { |a| from_names += "#{a.full_name} <#{a.email}>, "}
    from_names
  }

  def project_approval(project)
    @project = project
    mail(subject: "Please approve a project")
  end
end
