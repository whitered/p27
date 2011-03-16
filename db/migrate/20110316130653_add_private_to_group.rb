class AddPrivateToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :private, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :groups, :private
  end
end
