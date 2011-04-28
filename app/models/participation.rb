class Participation < ActiveRecord::Base

  belongs_to :user
  belongs_to :game

  validates_presence_of :user_id
  validates_presence_of :game_id
  validates_uniqueness_of :game_id, :scope => :user_id
  validates_presence_of :rebuys
  validates_inclusion_of :addon, :in => [true, false]
end
