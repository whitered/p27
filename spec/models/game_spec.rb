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

  it 'should have players' do
    Game.new.should respond_to(:players)
  end

  it 'should have can_be_edited_by? method' do
    Game.new.should respond_to(:can_be_edited_by?)
  end

  describe 'can_be_edited_by?' do

    before do
      @announcer = User.make!
      @group = Group.make!
      @game = Game.make!(:announcer => @announcer, :group => @group)
    end
    
    it 'should be false for nil' do
      @game.can_be_edited_by?(nil).should be_false
    end

    it 'should be false for outsider' do
      @game.can_be_edited_by?(User.make!).should be_false
    end

    it 'should be false for outsider even if he have announced it' do
      @game.can_be_edited_by?(@announcer).should be_false
    end

    it 'should be false for group member' do
      member = User.make!(:groups => [@group])
      @game.can_be_edited_by?(member).should be_false
    end

    it 'should be true for game announder while he is a member of the group' do
      @group.users << @announcer
      @game.can_be_edited_by?(@announcer).should be_true
    end

    it 'should be true for group admin' do
      admin = User.make!
      @group.users << admin
      @group.set_admin_status admin, true
      @game.can_be_edited_by?(admin).should be_true
    end

  end

  #it 'should have game_type' do
    #Game.new.should respond_to(:game_type)
  #end

  #describe 'game_type' do

    #before do
      #@game = Game.make(:announcer => User.make!, :group => Group.make!)
    #end

    #it 'should not be empty' do
      #@game.game_type = nil
      #@game.should be_invalid
      #@game.errors[:game_type].should_not be_empty
    #end

    #it 'can be cash' do
      #@game.game_type = 'cash'
      #@game.should be_valid
    #end

    #it 'can be tourney' do
      #@game.game_type = 'tourney'
      #@game.should be_valid
    #end

    #it 'can be rebuys' do
      #@game.game_type = 'rebuys'
      #@game.should be_valid
    #end
  #end

  it 'should have buyin' do
    Game.new.should respond_to(:buyin)
  end

  describe 'buyin' do
    it 'should not be nil' do
      game = Game.make(:announcer => User.make!, :group => Group.make!, :buyin => nil)
      game.should be_invalid
      game.errors[:buyin].should_not be_empty
      game.buyin = 0
      game.should be_valid
    end

    it 'should be zero by default' do
      Game.new.buyin.should eq(0)
    end
  end

  it 'should have rebuy' do
    Game.new.should respond_to(:rebuy)
  end

  describe 'rebuy' do
    it 'should not be nil' do
      game = Game.make(:announcer => User.make!, :group => Group.make!, :rebuy => nil)
      game.should be_invalid
      game.errors[:rebuy].should_not be_empty
      game.rebuy = 0
      game.should be_valid
    end

    it 'should be zero by default' do
      Game.new.rebuy.should eq(0)
    end
  end

  it 'should have addon' do
    Game.new.should respond_to(:addon)
  end

  describe 'addon' do
    it 'should not be nil' do
      game = Game.make(:announcer => User.make!, :group => Group.make!, :addon => nil)
      game.should be_invalid
      game.errors[:addon].should_not be_empty
      game.addon = 0
      game.should be_valid
    end

    it 'should be zero by default' do
      Game.new.addon.should eq(0)
    end
  end

  it 'should have game_type' do
    Game.new.should respond_to(:game_type)
  end

  describe 'game_type' do
    it 'should be cash if all costs are zeroes' do
      game = Game.make(:buyin => 0, :rebuy => 0, :addon => 0)
      game.game_type.should eq(:cash)
    end

    it 'should be tourney if buyin is present' do
      game = Game.make(:buyin => 100, :rebuy => 0, :addon => 0)
      game.game_type.should eq(:tourney)
    end

    it 'should be tourney with rebuys if rebuy is present' do
      game = Game.make(:buyin => 100, :rebuy => 100, :addon => 0)
      game.game_type.should eq(:tourney_with_rebuys)
    end
  end

  it 'should accept nested attributes for participations' do
    game = Game.new(:participations_attributes => [
      {:user_id => 1, :rebuys => 10, :addon => true, :win => 120},
      {:user_id => 4, :rebuys => 0, :addon => false, :win => 200}
    ])
    game.participations.size.should == 2
    first, second = game.participations

    first.user_id.should == 1
    first.rebuys.should == 10
    first.addon.should == true
    first.win.should == 120

    second.user_id.should == 4
    second.rebuys.should == 0
    second.addon.should == false
    second.win.should == 200
  end
end
