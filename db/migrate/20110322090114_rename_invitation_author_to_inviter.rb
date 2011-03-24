class RenameInvitationAuthorToInviter < ActiveRecord::Migration
  def self.up
    rename_column :invitations, :author_id, :inviter_id
  end

  def self.down
    rename_column :invitations, :inviter_id, :author_id
  end
end
