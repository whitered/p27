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

    it 'should be generated before save' do
      invitation = Invitation.create(:group_id => 1, :inviter_id => 2)
      invitation.code.should_not be_blank
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
end
