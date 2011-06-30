class AddDummyNameToParticipation < ActiveRecord::Migration
  def self.up
    add_column :participations, :dummy_name, :string
  end

  def self.down
    remove_column :participations, :dummy_name
  end
end
