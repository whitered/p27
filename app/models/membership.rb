class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates_presence_of :user_id
  validates_presence_of :group_id
  validates_inclusion_of :is_admin, :in => [true, false]
  validates_uniqueness_of :user_id, :scope => :group_id

end
