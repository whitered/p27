class Game < ActiveRecord::Base

  belongs_to :group
  belongs_to :announcer, :class_name => 'User'

  validates_presence_of :group_id
  validates_presence_of :announcer_id
  validates_datetime :date
end
