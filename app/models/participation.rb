class Participation < ActiveRecord::Base

  belongs_to :user
  belongs_to :game

  validates_presence_of :game_id
  validates_uniqueness_of :user_id, :scope => :game_id, :allow_nil => true
  validates_uniqueness_of :dummy_name, :scope => :game_id, :allow_nil => true
  validates_presence_of :dummy_name, :if => 'user_id.nil?'
  validates_inclusion_of :addon, :in => [true, false]

  def rebuys
    self[:rebuys] || 0
  end
end
