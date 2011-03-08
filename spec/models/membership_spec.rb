require 'spec_helper'

describe Membership do

  let(:m) { Membership.make }

  it 'should belong to group' do
    m.should respond_to(:group)
  end

  describe 'group' do
    it 'should not be nil' do
      Membership.make(:group_id => nil).should_not be_valid
    end
  end

  it 'should belong to user' do
    m.should respond_to(:user)
  end

  describe 'user' do
    it 'should not be nil' do
      Membership.create(:user_id => nil).should_not be_valid
    end
  end

  it 'should have is_admin' do
    m.should respond_to(:is_admin?)
  end

  describe 'is_admin' do
    it 'should be false by default' do
      Membership.new.is_admin?.should be_false
    end
  end


end
