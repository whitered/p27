require 'spec_helper'

describe User do

  describe 'blueprint' do
    it 'should produce valid user' do
      User.make.should be_valid
    end
  end

  it 'should have username' do
    User.make.should respond_to(:username)
  end

  describe 'username' do

    it 'should not be nil' do
      user = User.make( :username => nil )
      user.should_not be_valid
      user.errors[:username].should_not be_nil
    end

    it 'should be unique' do
      User.make!( :username => 'tommy' )
      user = User.make( :username => 'tommy' )
      user.should_not be_valid
      user.errors[:username].should_not be_nil
    end

    it 'should be unique case-insensitive' do
      User.make!( :username => 'billy' )
      user = User.make( :username => 'Billy' )
      user.should_not be_valid
      user.errors[:username].should_not be_nil
    end

    it 'should not contain restricted characters' do
      ' ?!\'\\/^:",.'.chars do |char|
        user = User.make( :username => 'name_' + char )
        user.should_not be_valid
        user.errors[:username].should_not be_nil
      end
    end

    it 'should not be too short' do
      user = User.make( :username => '12' )
      user.should_not be_valid
      user.errors[:username].should_not be_nil
    end

    it 'should not be too long' do
      user = User.make( :username => '12345678901234567' )
      user.should_not be_valid
      user.errors[:username].should_not be_nil
    end

  end

end
