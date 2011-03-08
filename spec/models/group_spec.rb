require 'spec_helper'

describe Group do

  describe 'blueprint' do

    it 'should make valid group' do
      Group.make.should be_valid
    end

  end


  it 'should have name' do
    Group.make.should respond_to(:name)
  end

  it 'should have users' do
    Group.make.should respond_to(:users)
  end

end
