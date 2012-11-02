class AddNotifyCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify_count, :integer, :default => 0, :null => false
  end
end
