class AddDetailsToParticipation < ActiveRecord::Migration
  def self.up
    add_column :participations, :rebuys, :integer, :null => false, :default => 0
    add_column :participations, :addon, :boolean, :null => false, :default => false
    add_column :participations, :place, :integer
    add_column :participations, :win, :integer
  end

  def self.down
    remove_column :participations, :win
    remove_column :participations, :place
    remove_column :participations, :addon
    remove_column :participations, :rebuys
  end
end
