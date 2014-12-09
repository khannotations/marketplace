desc "Notify the leaders of all expired Openings, and mark them as notified"
task :notify_expired => :environment do
  Opening.notify_expired
end