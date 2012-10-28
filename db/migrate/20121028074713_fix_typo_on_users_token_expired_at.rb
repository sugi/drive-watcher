class FixTypoOnUsersTokenExpiredAt < ActiveRecord::Migration
  def change
    rename_column :users, :token_expired_at, :token_expires_at
  end
end
