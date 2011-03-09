require 'spec_helper'

describe Group do

  let(:group) { Group.make }

  describe 'blueprint' do

    it 'should make valid group' do
      group.should be_valid
    end

  end

  it 'should have name' do
    group.should respond_to(:name)
  end

  it 'should have users' do
    group.should respond_to(:users)
  end


  it 'should have set_admin_status method' do
    group.should respond_to(:set_admin_status)
  end

  describe 'set_admin_status' do

    before do
      @group = Group.make!
      @member, @admin, @outsider = User.make!(3)
      @group.users << @member << @admin
      @group.memberships.find_by_user_id(@admin.id).is_admin = true
    end

    it 'should turn regular user to admin' do
      @group.set_admin_status @member, true
      @group.memberships.find_by_user_id(@member.id).is_admin?.should be_true
    end

    it 'should turn admin to regular user' do
      @group.set_admin_status @admin, false
      @group.memberships.find_by_user_id(@admin.id).is_admin?.should be_false
    end

    it 'should not raise exception if user is not a member of the group' do
      lambda {
        @group.set_admin_status @outsider, false
      }.should_not raise_exception
    end

    it 'should do nothing if user is not a member of the group' do
      lambda {
        @group.set_admin_status @outsider, true
      }.should_not change(@group.memberships, :count)
    end

  end


end
