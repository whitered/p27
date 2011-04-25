class AddDetailsToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :buyin, :integer, :null => false, :default => 0
    add_column :games, :rebuy, :integer, :null => false, :default => 0
    add_column :games, :addon, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :games, :addon
    remove_column :games, :rebuy
    remove_column :games, :buyin
  end
end
