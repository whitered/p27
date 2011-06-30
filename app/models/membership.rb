class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :inviter, :class_name => 'User'

  validates_presence_of :user_id
  validates_presence_of :group_id
  validates_inclusion_of :is_admin, :in => [true, false]
  validates_uniqueness_of :user_id, :scope => :group_id

  delegate :name, :owner, :to => :group, :prefix => true
  delegate :username, :to => :user, :prefix => true

  def user_can_destroy? user
    user && (user == self.user || group.user_is_admin?(user) || group.owner == user)
  end

end
