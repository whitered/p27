require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the GamesHelper. For example:
#
# describe GamesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe GamesHelper do

  describe '#participation_link' do

    before do
      @group = Group.make!
      @user = User.make!
      @game = Game.make!(:announcer => User.make!, :group => @group)
    end

    let(:link) { participation_link(@game, @user) }

    it 'should be nil if user not a member' do
     link.should be_nil
    end

    it 'should be +1 if user have not joined game yet' do
      @group.users << @user
      Capybara.string(link).should have_link(t('games.game.join'), :href => join_game_path(@game), :method => :post)
    end

    it 'should be -1 if user have joined game' do
      @group.users << @user
      @game.players << @user
      Capybara.string(link).should have_link(t('games.game.leave'), :href => leave_game_path(@game), :method => :post)
    end
  end
end
