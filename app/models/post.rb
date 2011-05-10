class Post < ActiveRecord::Base

  acts_as_commentable

  belongs_to :author, :class_name => 'User'
  belongs_to :group

  has_many :visits, :as => :visitable

  before_save do
    self.body.gsub!(/$\s*^/m, '<br>')
    self.body = Sanitize.clean(self.body, Sanitize::Config::POST)
  end


  attr_protected :group_id, :author_id

  validates_presence_of :author_id

  def can_be_edited_by? user
    user && (author == user || group && (group.user_is_admin?(user) || group.owner == user))
  end

  def can_be_commented_by? user
    user && user.is_insider_of?(group)
  end

  def new_comments_count_for user
    unless user.nil?
      visit = visits.find_by_user_id(user.id)
      if visit.nil?
        comment_threads.size
      else
        comment_threads.size - visit.existing_comments
      end
    end
  end

end
