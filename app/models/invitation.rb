class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :author, :class_name => 'User'
  belongs_to :membership

  attr_accessor :recipient

  validates_presence_of :group_id
  validates_presence_of :author
  validates_inclusion_of :declined, :in => [false, true]
end
