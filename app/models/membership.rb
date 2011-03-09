class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates_presence_of :user
  validates_presence_of :group

  validates_inclusion_of :is_admin, :in => [true, false]
end
