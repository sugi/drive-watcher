class UserMailer < ActionMailer::Base
  default :from => "Google Drive Notifier <#{Rails.configuration.mail_from}>"

  def notify_unread(user)
    @user = user
    mail :to => user.notify_email
  end

end
