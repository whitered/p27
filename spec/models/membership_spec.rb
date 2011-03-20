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


end
