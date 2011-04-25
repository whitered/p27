class AddDetailsToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :buyin, :integer
    add_column :games, :rebuy, :integer
    add_column :games, :addon, :integer
  end

  def self.down
    remove_column :games, :addon
    remove_column :games, :rebuy
    remove_column :games, :buyin
  end
end
