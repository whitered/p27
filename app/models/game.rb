class Game < ActiveRecord::Base

  belongs_to :group
  belongs_to :announcer, :class_name => 'User'

  has_many :participations
  has_many :players, :through => :participations, :source => :user

  validates_presence_of :group_id
  validates_presence_of :announcer_id
  validates_datetime :date
  validates_presence_of :buyin
  validates_presence_of :rebuy
  validates_presence_of :addon
  validates_inclusion_of :archived, :in => [true, false]

  accepts_nested_attributes_for :participations

  scope :current, where(:archived => false)
  scope :archive, where(:archived => true)

  def can_be_edited_by? user
    group.user_is_admin?(user) || (group.users.include?(user) && announcer == user)
  end

  def game_type
    if buyin.zero?
      :cash
    elsif rebuy.zero?
      :tourney
    else
      :tourney_with_rebuys
    end
  end
end
