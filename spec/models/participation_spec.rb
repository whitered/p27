require 'spec_helper'

describe Participation do

  it 'should belong to user' do
    Participation.new.should respond_to(:user)
  end

  describe 'user' do
    it 'should present' do
      p = Participation.make(:user => nil, :game_id => 1)
      p.should be_invalid
      p.errors[:user_id].should_not be_empty
      p.user = User.make!
      p.should be_valid
    end
  end

  it 'should belong to game' do
    Participation.new.should respond_to(:game)
  end

  describe 'game' do
    it 'should present' do
      p = Participation.make(:game => nil, :user => User.make!)
      p.should be_invalid
      p.errors[:game_id].should_not be_empty
      p.game = Game.make!(:announcer => User.make!, :group => Group.make!)
      p.should be_valid
    end

    it 'should be unique for current user' do
      user = User.make!
      game = Game.make!(:announcer => User.make!, :group => Group.make!)
      Participation.make!(:game => game, :user => user)
      p = Participation.make(:game => game, :user => user)
      p.should be_invalid
      p.errors[:game_id].should_not be_empty
    end
  end
end
