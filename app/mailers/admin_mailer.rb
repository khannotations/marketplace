class AdminMailer < ActionMailer::Base
  default from: "Yale Projects Board <noreply@projectsboard.io>",
          to: Proc.new {
            User.where(is_admin: true)
              .map{ |a| "#{a.full_name} <#{a.email}>"}.join(",")
          }

  def project_approval(project)
    @project = project
    mail(subject: "Please approve a project")
  end

  def job_ran
    mail(subject: "The cron job just ran")
  end
end
