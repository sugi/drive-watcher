class User < ActiveRecord::Base
  attr_accessible :account, :auth_token, :check_target, :error_count, :last_checked_at, :last_notified_at, :name, :notify_email, :refresh_token, :suspended, :token_expired_at, :token_issued_at
end
