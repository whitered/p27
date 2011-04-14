require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Join Game" do

  background do
    @group = Group.make!
    @game = Game.make!(:announcer => User.make!, :group => @group)
    @user = User.make!
    @group.users << @user
  end

  scenario 'group member joins game from games index page' do
    login @user
    visit group_games_path(@group)
    within('#game_' + @game.id.to_s) do
      click_link(t('games.game.join'))
    end
    current_path.should eq(game_path(@game))
    page.find('#game .game_players').should have_content(@user.username)
  end

end
