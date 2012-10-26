if Rails.env == "production"
   DriveWatcher::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[DriveWatcher ERROR] ",
    :sender_address => %{"Error notifier" <sugi@nemui.org>},
    :exception_recipients => %w{sugi@nemui.org}
end

