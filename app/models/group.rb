class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships

  def set_admin_status user, status
    membership = memberships.find_by_user_id(user.id)
    membership && membership.update_attribute(:is_admin, status)
  end

  def user_is_admin? user
    membership = memberships.find_by_user_id(user.id)
    membership && membership.is_admin?
  end
end
