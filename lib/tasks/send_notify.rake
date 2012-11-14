desc "Send unread notify for all user"
task :send_unread_notify => :environment do
  orig_locale = I18n.locale
  orig_tz = Time.zone
  User.active.each do |user|
    user.last_checked_at.to_i > Time.now.to_i - user.check_interval * 3600 and next
    user.locale.blank? or I18n.locale = user.locale.to_sym
    Time.zone = user.time_zone
    begin
      user.send_unread_notify
    rescue => e
      Rails.logger.error "Failed to send notify for #{user.account}: '#{e.class}: #{e.message}'"
    end
  end
  I18n.locale = orig_locale
  Time.zone = orig_tz
end
