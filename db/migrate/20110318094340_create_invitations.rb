class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :user_id
      t.string :email
      t.integer :group_id
      t.integer :author_id
      t.string :message
      t.integer :membership_id
      t.boolean :declined
      t.string :code

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
