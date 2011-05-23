class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
    :username, :login, :name

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


  # Attempt to find a user by it's email. If a record is found, send new
  # password instructions to it. If not user is found, returns a new user
  # with an email not found error.
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end

  def self.find_recoverable_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
    (case_insensitive_keys || []).each { |k| attributes[k].try(:downcase!) }

    attributes = attributes.slice(*required_attributes)
    attributes.delete_if { |key, value| value.blank? }

    if attributes.size == required_attributes.size
      if attributes.has_key?(:login)
        login = attributes.delete(:login)
        record = find_record(login)
      else
        record = where(attributes).first
      end
    end

    unless record
      record = new

      required_attributes.each do |key|
        value = attributes[key]
        record.send("#{key}=", value)
        record.errors.add(key, value.present? ? error : :blank)
      end
    end
    record
  end

  def self.find_record(login)
    where(["username = :value OR email = :value", { :value => login }]).first
  end

end
