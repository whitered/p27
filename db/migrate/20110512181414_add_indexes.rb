class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :memberships, :user_id
    add_index :memberships, :group_id
    add_index :memberships, :inviter_id
    add_index :groups, :owner_id
    add_index :games, :announcer_id
    add_index :games, :group_id
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comments, :parent_id
    add_index :visits, :user_id
    add_index :visits, [:visitable_id, :visitable_type]
    add_index :posts, :author_id
    add_index :posts, :group_id
    add_index :invitations, :user_id
    add_index :invitations, :group_id
    add_index :invitations, :inviter_id
    add_index :invitations, :membership_id
    add_index :participations, :user_id
    add_index :participations, :game_id
  end

  def self.down
    remove_index :participations, :column => :game_id
    remove_index :participations, :column => :user_id
    remove_index :invitations, :column => :membership_id
    remove_index :invitations, :column => :inviter_id
    remove_index :invitations, :column => :group_id
    remove_index :invitations, :column => :user_id
    remove_index :posts, :column => :group_id
    remove_index :posts, :column => :author_id
    remove_index :visits, :column => [:visitable_id, :visitable_type]
    remove_index :visits, :column => :user_id
    remove_index :comments, :column => :parent_id
    remove_index :comments, :column => [:commentable_id, :commentable_type]
    remove_index :games, :column => :group_id
    remove_index :games, :column => :announcer_id
    remove_index :groups, :column => :owner_id
    remove_index :memberships, :column => :inviter_id
    remove_index :memberships, :column => :group_id
    remove_index :memberships, :column => :user_id
  end
end
