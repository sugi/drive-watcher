class UserMailer < ActionMailer::Base
  default :from => "drivenotify@nemui.org"

  def notify_unread(user)
    @user = user
    mail :to => user.notify_email, :from => "drivenotify-#{user.notify_email.tr('@', '=')}@nemui.org"
    @user.update_attribute :last_notified_at, DateTime.now
  end

end
