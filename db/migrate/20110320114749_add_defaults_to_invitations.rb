class AddDefaultsToInvitations < ActiveRecord::Migration
  def self.up
    change_column :invitations, :declined, :boolean, :default => false, :null => false
  end

  def self.down
    change_column :invitations, :declined, :boolean
  end
end
