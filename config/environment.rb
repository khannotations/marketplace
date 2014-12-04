# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

require 'casclient'
require 'casclient/frameworks/rails/filter'
CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "https://secure.its.yale.edu/cas/",
  :username_session_key => :cas_user
)

unless Rails.env.production?
  credentials = YAML.load_file("#{Rails.root}/config/credentials.yml")
  ENV['CAS_NETID'] = credentials['cas_username']
  ENV['CAS_PASS'] = credentials['cas_password']
  ENV['SENDGRID_USERNAME'] = credentials['sendgrid_username']
  ENV['SENDGRID_PASSWORD'] = credentials['sendgrid_password']
end

ActionMailer::Base.smtp_settings = {
  :user_name => "#{ENV['SENDGRID_USERNAME']}",
  :password => "#{ENV['SENDGRID_USERNAME']}",
  :domain => 'projectsboard.io',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}