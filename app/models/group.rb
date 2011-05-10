class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships
  belongs_to :owner, :class_name => 'User'
  has_many :posts
  has_many :games

  validates_inclusion_of :private, :in => [false, true]
  validates_inclusion_of :hospitable, :in => [false, true]

  attr_accessible :private, :hospitable, :name

  def set_admin_status user, status
    membership = memberships.find_by_user_id(user.id)
    membership && membership.update_attribute(:is_admin, status)
  end

  def user_is_admin? user
    return false if user.nil?
    membership = memberships.find_by_user_id(user.id)
    membership && membership.is_admin?
  end

  def public?
    !private?
  end

  def user_can_post? user
    user && (user == owner || users.include?(user))
  end

  def user_can_announce_game? user
    users.include? user
  end

  def user_can_view? user
    public? || (user && user.is_insider_of?(self))
  end
end
