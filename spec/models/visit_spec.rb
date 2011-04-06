require 'spec_helper'

describe Visit do

  it 'should have user' do
    Visit.new.should respond_to(:user)
  end

  describe 'user' do
    it 'should not be nil' do
      visit = Visit.make(:user => nil, :visitable => Post.make!(:author => User.make!))
      visit.should be_invalid
      visit.errors[:user_id].should_not be_empty
      visit.user = User.make!
      visit.should be_valid
    end

    it 'should be unique for given visitable' do
      user = User.make!
      visitable = Post.make!(:author => user)
      Visit.make!(:user => user, :visitable => visitable)
      visit = Visit.make(:user => user, :visitable => visitable)
      visit.should be_invalid
      visit.errors[:user_id].should_not be_empty
      visit.visitable = Post.make!(:author => user)
      visit.should be_valid
    end
  end

  it 'should have visitable' do
    Visit.new.should respond_to(:visitable)
  end
  
  describe 'visitable' do
    it 'should not be nil' do
      visit = Visit.make(:user => User.make!, :visitable => nil)
      visit.should be_invalid
      visit.errors[:visitable_id].should_not be_empty
      visit.visitable = Post.make!(:author => User.make!)
      visit.should be_valid
    end
  end

end
