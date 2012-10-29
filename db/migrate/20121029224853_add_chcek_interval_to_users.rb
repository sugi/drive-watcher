class AddChcekIntervalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :check_interval, :integer, :null => false, :default => 12
  end
end
