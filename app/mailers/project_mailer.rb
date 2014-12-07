class ProjectMailer < ActionMailer::Base
  default from: "Yale Projects Board <noreply@projectsboard.io>"

  def project_created(project)
    @project = project
    to = project.leaders.map{ |l| "#{l.full_name} <#{l.email}>"}.join(",")
    mail(to: to, subject: "#{project.name} successfully created!")
  end

  def expired_opening(opening)
    @opening = opening
    to = @opening.project.leaders.map{ |l| "#{l.full_name} <#{l.email}>"}.join(",")
    mail(to: to, subject: "Your project opening #{@opening.name} has expired}")
  end
end
