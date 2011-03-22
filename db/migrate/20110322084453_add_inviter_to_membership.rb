class AddInviterToMembership < ActiveRecord::Migration
  def self.up
    add_column :memberships, :inviter_id, :integer
  end

  def self.down
    remove_column :memberships, :inviter_id
  end
end
