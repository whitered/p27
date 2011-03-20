class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :author, :class_name => 'User'
  belongs_to :membership

  attr_accessor :recipient

  validates :email, :email => true, :unless => 'email.blank?'
  validates_presence_of :group_id
  validates_presence_of :author_id
  validates_inclusion_of :declined, :in => [false, true]

  before_create :generate_code

private

  def generate_code
    self.code = ActiveSupport::SecureRandom.hex(20)
  end
end
