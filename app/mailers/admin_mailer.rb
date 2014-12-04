class AdminMailer < ActionMailer::Base
  default from: "yale@projectsboard.io",
          to: Proc.new {
            User.where(is_admin: true)
              .map{ |a| "#{a.full_name} <#{a.email}>"}.join(",")
          }

  def project_approval(project)
    @project = project
    mail(subject: "Please approve a project")
  end
end
