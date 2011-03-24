require 'spec_helper'

describe Invitation do

  let(:invite) { Invitation.new }

  it 'should have user' do
    invite.should respond_to(:user)
  end

  it 'should have email' do
    invite.should respond_to(:email)
  end

  describe 'email' do
    it 'should be an email' do
      %w( invalid@email @email.com admin-at-server.com email@.com ).each do |email|
        invitation = Invitation.new(:email => email)
        invitation.valid?
        invitation.errors[:email].should_not be_empty
      end
    end

    it 'can be empty' do
      invitation = Invitation.new(:email => nil)
      invitation.valid?
      invitation.errors[:email].should be_blank
    end
  end

  it 'should have group' do
    invite.should respond_to(:group)
  end

  describe 'group' do
    it 'should not be nil' do
      invitation = Invitation.new(:group => nil)
      invitation.should_not be_valid
      invitation.errors[:group_id].should_not be_empty
    end
  end

  it 'should have message' do
    invite.should respond_to(:message)
  end

  it 'should have inviter' do
    invite.should respond_to(:inviter)
  end

  describe 'inviter' do
    it 'should not be nil' do
      invitation = Invitation.new(:inviter => nil)
      invitation.should_not be_valid
      invitation.errors[:inviter_id].should_not be_empty
    end
  end

  it 'should have membership' do
    invite.should respond_to(:membership)
  end

  it 'should have declined' do
    invite.should respond_to(:declined?)
  end

  describe 'declined' do
    it 'should not be nil' do
      invitation = Invitation.new(:declined => nil)
      invitation.should_not be_valid
      invitation.errors[:declined].should_not be_empty
    end

    it 'should be false by default' do
      Invitation.new.declined.should eq(false)
    end
  end

  it 'should have code' do
    invite.should respond_to(:code)
  end

  describe 'code' do

    it 'should be generated before save if user not exists' do
      invitation = Invitation.create(:group_id => 1, :inviter_id => 2, :email => Faker::Internet.email)
      invitation.code.should_not be_blank
    end
    
    it 'should not be generated if user exists' do
      invitation = Invitation.create(:group_id => 1, :inviter_id => 2, :user => User.make!)
      invitation.code.should be_nil
    end

   
  end

  it 'should have recipient' do
    invite.should respond_to(:recipient)
  end

  it 'should have unique user id in a group' do
    group = Group.make!
    user = User.make!
    Invitation.make!(:group => group, :user => user, :inviter => User.make!)
    invitation = Invitation.make(:group => group, :user => user, :inviter => User.make!)
    invitation.should_not be_valid
    invitation.errors[:user_id].should_not be_empty
    invitation.user = User.make!
    invitation.should be_valid
  end

  it 'should have unique email in a group' do
    group = Group.make!
    email = Faker::Internet.email
    Invitation.make!(:group => group, :email => email, :inviter => User.make!)
    invitation = Invitation.make(:group => group, :email => email, :inviter => User.make!)
    invitation.should_not be_valid
    invitation.errors[:email].should_not be_empty
    invitation.email = Faker::Internet.email
    invitation.should be_valid
  end

  it 'should have accept! method' do
    Invitation.new.should respond_to(:accept!)
  end

  describe 'accept!' do

    let(:email_invitation) { Invitation.create!(:email => Faker::Internet.email, :group => Group.make!, :inviter => User.make!) }
    let(:user_invitation) { Invitation.create(:user => User.make!, :group => Group.make!, :inviter => User.make!) }

    it 'should require user to be given as argument if self.user is nil' do
      lambda do
        email_invitation.accept!
      end.should raise_exception(ArgumentError)
    end

    it 'should add user to the group' do
      user = User.make!
      email_invitation.accept! user 
      email_invitation.group.users.should include(user)
    end

    it 'should add own user to the group' do
      user_invitation.accept!
      user_invitation.group.users.should include(user_invitation.user)
    end

    it 'should remove itself after accepting' do
      user_invitation.accept!
      Invitation.find_by_id(user_invitation.id).should be_nil
    end

    it 'should set inviter on membership' do
      user_invitation.accept!
      membership = Membership.find(:first, :conditions => { :user_id => user_invitation.user.id, :group_id => user_invitation.group.id })
      membership.inviter.should eq(user_invitation.inviter)
    end

  end

end
