require 'spec_helper'

describe Participation do

  let(:game) { Game.make!(:announcer => User.make!, :group => Group.make!) }

  it 'should belong to user' do
    Participation.new.should respond_to(:user)
  end

  describe 'user' do
    it 'should be unique in scope of game' do
      user = User.make!
      Participation.make!(:user => user, :game => game)
      p = Participation.make(:user => user, :game => game)
      p.should be_invalid
      p.errors[:user_id].should_not be_empty
      p.user = User.make!
      p.should be_valid
    end
  end

  it 'should have dummy_name' do
    Participation.new.should respond_to(:dummy_name)
  end

  describe 'dummy_name' do
    it 'should be unique in scope of game' do
      dname = 'Dummy'
      Participation.make!(:dummy_name => dname, :game => game)
      p = Participation.make(:dummy_name => dname, :game => game)
      p.should be_invalid
      p.errors[:dummy_name].should_not be_empty
      p.dummy_name = 'Another name'
      p.should be_valid
    end

    it 'should present if user is not assigned' do
      p = Participation.make(:game => game)
      p.should be_invalid
      p.errors[:dummy_name].should_not be_empty
      p.dummy_name = 'Dummy'
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
      p.errors[:game].should_not be_empty
      p.game = game
      p.should be_valid
    end
  end

  it 'should have rebuys' do
    Participation.new.should respond_to(:rebuys)
  end

  describe 'rebuys' do
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

  describe 'win' do

    it 'should be money' do
      Participation.new(:game => game).win.should be_a(Money)
    end

    it 'should take currency from game' do
      game.update_attribute(:currency, 'RUB')
      p = game.participations.create(:user => User.make!, :win_cents => 12340)
      p.win.should == 123.4.to_money(:rub)
    end
    
  end

  describe 'win=' do

    before do
      game.update_attribute(:currency, 'EUR')
      @p = game.participations.create(:user => User.make!)
    end

    it 'should raise exception if currencies do not match' do
      lambda do
        @p.win = 3.to_money
      end.should raise_exception(ArgumentError)
    end

    it 'should set win_cents' do
      lambda do
        @p.win = 3.to_money(:eur)
        @p.save
        @p.reload
      end.should change{ @p.win_cents }.from(nil).to(300)
    end
      
  end
end
