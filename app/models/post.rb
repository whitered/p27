class Post < ActiveRecord::Base

  belongs_to :author, :class_name => 'User'
  belongs_to :group

  attr_protected :group_id, :author_id

  validates_presence_of :author_id

  def can_be_edited_by? user
    user && (author == user || group && (group.user_is_admin?(user) || group.owner == user))  
  end

end
