class Game < ActiveRecord::Base

  belongs_to :group
  belongs_to :announcer, :class_name => 'User'

  has_many :participations
  has_many :users, :through => :participations

  validates_presence_of :group_id
  validates_presence_of :announcer_id
  validates_datetime :date

  def can_be_edited_by? user
    group.user_is_admin?(user) || (group.users.include?(user) && announcer == user)
  end
end
