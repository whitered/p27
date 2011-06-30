require 'spec_helper'

describe Membership do

  let(:m) { Membership.make }

  it 'should belong to group' do
    m.should respond_to(:group)
  end

  describe 'group' do
    it 'should not be nil' do
      membership = Membership.make(:group_id => nil)
      membership.should_not be_valid
      membership.errors[:group_id].should_not be_empty
    end
  end

  it 'should belong to user' do
    m.should respond_to(:user)
  end

  describe 'user' do
    it 'should not be nil' do
      membership = Membership.create(:user_id => nil)
      membership.should_not be_valid
      membership.errors[:user_id].should_not be_empty
    end
  end

  it 'should have is_admin' do
    m.should respond_to(:is_admin?)
  end

  describe 'is_admin' do
    it 'should be false by default' do
      m = Membership.new
      m.is_admin.should_not be_nil
      m.is_admin.should be_false
    end
  end

  it 'should have unique user_id in a group' do
    group = Group.make!
    user = User.make!
    Membership.create(:group => group, :user => user)
    membership = Membership.new(:group => group, :user => user)
    membership.should_not be_valid
    membership.errors[:user_id].should_not be_empty
    membership.user = User.make!
    membership.should be_valid
  end

  it 'should have inviter' do
    Membership.new.should respond_to(:inviter)
  end

  it 'should have user_can_destroy? method' do
    Membership.new.should respond_to(:user_can_destroy?)
  end

  describe 'user_can_destroy?' do

    before do
      @group = Group.make!(:owner => User.make!)
      @user = User.make!
      @membership = @group.memberships.create(:user => @user)
    end

    it 'should be false for nil' do
      @membership.user_can_destroy?(nil).should be_false
    end

    it 'should be false for outsider' do
      @membership.user_can_destroy?(User.make!).should be_false
    end

    it 'should be false for member' do
      member = User.make!
      @group.users << member
      @membership.user_can_destroy?(member).should be_false
    end

    it 'should be true for admin' do
      admin = User.make!
      @group.users << admin
      @group.set_admin_status admin, true
      @membership.user_can_destroy?(admin).should be_true
    end

    it 'should be true for group owner' do
      @membership.user_can_destroy?(@group.owner).should be_true
    end

    it 'should be true for user himself' do
      @membership.user_can_destroy?(@user).should be_true
    end
  end
end
