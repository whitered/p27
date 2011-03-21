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
      user.errors[:username].should_not be_empty
    end

    it 'should be unique' do
      User.make!( :username => 'tommy' )
      user = User.make( :username => 'tommy' )
      user.should_not be_valid
      user.errors[:username].should_not be_empty
    end

    it 'should be unique case-insensitive' do
      User.make!( :username => 'billy' )
      user = User.make( :username => 'Billy' )
      user.should_not be_valid
      user.errors[:username].should_not be_empty
    end

    it 'should not contain restricted characters' do
      ' ?!\'\\/^:",.'.chars do |char|
        user = User.make( :username => 'name_' + char )
        user.should_not be_valid
        user.errors[:username].should_not be_empty
      end
    end

    it 'should not be too short' do
      user = User.make( :username => '12' )
      user.should_not be_valid
      user.errors[:username].should_not be_empty
    end

    it 'should not be too long' do
      user = User.make( :username => '12345678901234567' )
      user.should_not be_valid
      user.errors[:username].should_not be_empty
    end

  end

  it 'should have login' do
    User.make.should respond_to(:login)
  end

  it 'should have groups' do
    User.make.should respond_to(:groups)
  end

  describe 'to_param' do

    it 'should return downcased username' do
      user = User.make!(:username => 'Bobby')
      user.to_param.should eq('bobby')
    end

  end

  it 'should have own_groups' do
    User.make.should respond_to(:own_groups)
  end

  it 'should have is_insider_of? method' do
    User.make.should respond_to(:is_insider_of?)
  end

  describe 'is_insider_of?' do

    before do
      @group = Group.make!
      @user = User.make!
    end

    it 'should be true if user is a member of the group' do
      @group.users << @user
      @user.is_insider_of?(@group).should be_true
    end

    it 'should be true if user is an owner of the group' do
      @group.owner = @user
      @group.save!
      @user.is_insider_of?(@group).should be_true
    end

    it 'should be false if user is not a member or owner of the group' do
      @user.is_insider_of?(@group).should be_false
    end

  end

  it 'should have email' do
    User.make.should respond_to(:email)
  end

  describe 'email' do
    it 'should be unique' do
      User.make!(:email => 'user@email.com')
      user = User.make(:email => 'user@email.com')
      user.should_not be_valid
      user.errors[:email].should_not be_empty
    end
  end

end
