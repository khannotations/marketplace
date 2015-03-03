desc "Notify the leaders of all expired projects, and mark them as notified"
task :notify_expired => :environment do
  Project.notify_expired
end