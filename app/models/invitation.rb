class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :inviter, :class_name => 'User'
  belongs_to :membership

  attr_accessor :recipient

  validates :email, :email => true, :unless => 'email.blank?'
  validates_presence_of :group_id
  validates_presence_of :inviter_id
  validates_inclusion_of :declined, :in => [false, true]
  validates_uniqueness_of :user_id, :scope => :group_id, :unless => 'user_id.blank?'
  validates_uniqueness_of :email, :scope => :group_id, :unless => 'email.blank?'

  before_create :generate_code

  delegate :username, :to => :inviter, :prefix => true
  delegate :name, :to => :group, :prefix => true

  def accept! user=nil
    user ||= self.user
    raise ArgumentError if user.nil?
    Membership.create!(:user => user, :group => group, :inviter => inviter)
    destroy
  end

  def self.find_by_email_downcase email
    where('lower(email) = ?', email.downcase)
  end

private

  def generate_code
    self.code = ActiveSupport::SecureRandom.hex(20) if user.nil?
  end
end
