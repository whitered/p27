require 'spec_helper'

describe Participation do

  let(:game) { Game.make!(:announcer => User.make!, :group => Group.make!) }

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
      p.game = game
      p.should be_valid
    end

    it 'should be unique for current user' do
      user = User.make!
      Participation.make!(:game => game, :user => user)
      p = Participation.make(:game => game, :user => user)
      p.should be_invalid
      p.errors[:game_id].should_not be_empty
    end
  end

  it 'should have rebuys' do
    Participation.new.should respond_to(:rebuys)
  end

  describe 'rebuys' do
    it 'should not be nil' do
      p = Participation.make(:game => game, :user => User.make!, :rebuys => nil)
      p.should be_invalid
      p.errors[:rebuys].should_not be_empty
      p.rebuys = 0
      p.should be_valid
    end
    
    it 'should be 0 by default' do
      Participation.new.rebuys.should eq(0)
    end
  end

  it 'should have addon' do
    Participation.new.should respond_to(:addon?)
  end

  describe 'addon' do
    it 'should not be nil' do
      p = Participation.make(:game => game, :user => User.make!, :addon => nil)
      p.should be_invalid
      p.errors[:addon].should_not be_nil
      p.addon = false
      p.should be_valid
    end

    it 'should be false by default' do
      Participation.new.addon.should eq(false)
    end
  end

  it 'should have place' do
    Participation.new.should respond_to(:place)
  end

  it 'should have win' do
    Participation.new.should respond_to(:win)
  end
end
