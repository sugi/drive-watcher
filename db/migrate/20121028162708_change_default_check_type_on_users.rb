class ChangeDefaultCheckTypeOnUsers < ActiveRecord::Migration
  def up
    change_column :users, :check_target, :string, :null => false, :default => 'default'
  end

  def down
    change_column :users, :check_target, :string, :null => false, :default => 'all'
  end
end
