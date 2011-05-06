class AddArchivedToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :archived, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :games, :archived
  end
end
