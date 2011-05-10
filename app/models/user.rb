class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :login

  attr_accessor :login

  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :own_groups, :class_name => 'Group', :foreign_key => 'owner_id'
  has_many :invitations
  has_many :visits
  has_many :participations
  has_many :games, :through => :participations

  validates_presence_of :username
  validates_uniqueness_of :username, :case_sensitive => false
  validates_format_of :username, :with => /\A[\w\d]{3,16}\Z/

  def to_param
    username.downcase
  end

  def is_insider_of? group
    groups.exists?(group) || own_groups.exists?(group)
  end

  def self.find_by_username_or_email name
    where(["username = :value OR email = :value", { :value => name }]).first
  end

  def self.find_by_username_downcase name
    where([ 'lower(username) = ?', name.downcase ]).first
  end

protected

  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    where(conditions).where(["username = :value OR email = :value", { :value => login }]).first
  end

end
