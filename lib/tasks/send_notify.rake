desc "Send unread notify for all user"
task :send_unread_notify => :environment do
  User.all.each do |user|
    user.last_checked_at.to_i > Time.now.to_i - user.check_interval * 3600 and next
    user.send_unread_notify
  end
end
