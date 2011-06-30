class FixGameDefaultValues < ActiveRecord::Migration
  def self.up
    change_column :games, :buyin, :integer, :null => true, :default => nil
    change_column :games, :rebuy, :integer, :null => true, :default => nil
    change_column :games, :addon, :integer, :null => true, :default => nil
  end

  def self.down
    change_column :games, :buyin, :integer, :null => false, :default => 0
    change_column :games, :rebuy, :integer, :null => false, :default => 0
    change_column :games, :addon, :integer, :null => false, :default => 0
  end
end
