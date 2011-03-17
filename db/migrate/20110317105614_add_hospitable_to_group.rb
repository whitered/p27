class AddHospitableToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :hospitable, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :groups, :hospitable
  end
end
