class FixVisitsDefaultValues < ActiveRecord::Migration
  def self.up
    change_column :visits, :existing_comments, :integer, :default => nil, :null => true
    change_column :participations, :rebuys, :integer, :default => nil, :null => true
  end

  def self.down
    change_column :participations, :rebuys, :integer, :default => 0, :null => false
    change_column :visits, :existing_comments, :integer, :default => 0, :null => false
  end
end
