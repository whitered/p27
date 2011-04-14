require 'spec_helper'

describe Game do

  it 'should have group' do
    Game.new.should respond_to(:group)
  end

  describe 'group' do
    it 'should not be nil' do
      game = Game.make(:group => nil, :announcer => User.make!)
      game.should be_invalid
      game.errors[:group_id].should_not be_empty
      game.group = Group.make!
      game.should be_valid
    end
  end

  it 'should have date' do
    Game.new.should respond_to(:date)
  end

  describe 'date' do
    it 'should not be nil' do
      game = Game.make(:group => Group.make!, :announcer => User.make!, :date => nil)
      game.should be_invalid
      game.errors[:date].should_not be_empty
      game.date = Date.today
      game.should be_valid
    end
  end

  it 'should have announcer' do
    Game.new.should respond_to(:announcer)
  end

  describe 'announcer' do
    it 'should not be nil' do
      game = Game.make(:announcer => nil, :group => Group.make!)
      game.should be_invalid
      game.errors[:announcer_id].should_not be_empty
      game.announcer = User.make!
      game.should be_valid
    end
  end
  
  it 'should have description' do
    Game.new.should respond_to(:description)
  end

  it 'should have users' do
    Game.new.should respond_to(:users)
  end

end
