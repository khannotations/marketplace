class ProjectMailer < ActionMailer::Base
  default from: "Yale Projects Board <noreply@projectsboard.io>"

  def created(project)
    @project = project
    to = leader_emails @project
    mail(to: to, subject: "#{project.name} successfully created!")
  end

  def contact(project, user)
    @project = project
    @user = user
    to = leader_emails @project
    mail(to: to, cc: "#{@user.full_name} <#{@user.email}>",
      subject: "#{user.first_name} expressed interest in #{project.name}")
  end

  def expired(project)
    @project = project
    to = leader_emails @project
    if (to != "")
      mail(to: to, subject: "Your posting #{@project.name} has expired")
    else
      puts "no leaders for project #{project.name}."
    end
  end

  protected

  def leader_emails(project)
    project.leaders.map{ |l| "#{l.full_name} <#{l.email}>"}.join(", ")
  end
end
