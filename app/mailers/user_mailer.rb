class UserMailer < ActionMailer::Base
  default from: "Yale Projects Board <noreply@projectsboard.io>"

  def digest(user)
    @projects = user.digest_projects
    mail(to: user.email, subject: "Check out these awesome projects!")
  end
end
