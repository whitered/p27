class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships
  belongs_to :owner, :class_name => 'User'

  validates_inclusion_of :private?, :in => [false, true]

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
end
