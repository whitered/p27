class AddExistingCommentsToVisits < ActiveRecord::Migration
  def self.up
    add_column :visits, :existing_comments, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :visits, :existing_comments
  end
end
