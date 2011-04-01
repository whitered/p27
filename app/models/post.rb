class Post < ActiveRecord::Base

  belongs_to :author, :class_name => 'User'
  belongs_to :group

  has_many :comments, :as => :commentable

  attr_protected :group_id, :author_id

  validates_presence_of :author_id

  def can_be_edited_by? user
    user && (author == user || group && (group.user_is_admin?(user) || group.owner == user))  
  end

  def can_be_commented_by? user
    user && user.is_insider_of?(group)
  end

end
