class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :account, :null => false
      t.string :name
      t.string :notify_email
      t.string :refresh_token
      t.string :auth_token
      t.datetime :token_issued_at
      t.datetime :token_expired_at
      t.integer :error_count, :null => false, :default => 0
      t.boolean :suspended, :null => false, :default => false
      t.datetime :last_checked_at
      t.datetime :last_notified_at
      t.string :check_target, :null => false, :default => 'all'

      t.timestamps
    end
  end
end
