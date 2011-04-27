require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Join Game" do

  background do
    @group = Group.make!
    @game = Game.make!(:announcer => User.make!, :group => @group)
    @user = User.make!
  end

  context 'group member' do

    before do
      @group.users << @user
    end

    scenario 'joins game from games index page' do
      login @user
      visit group_games_path(@group)
      within('#game_' + @game.id.to_s) do
        click_link(t('games.game.join'))
      end
      current_path.should eq(game_path(@game))
      page.find('#game .game_players').should have_content(@user.username)
    end

    scenario 'joins game from game page' do
      login @user
      visit game_path(@game)
      within('#game') do
        click_link(t('games.game.join'))
      end
      current_path.should eq(game_path(@game))
      page.find('#game .game_players').should have_content(@user.username)
    end

  end

  context 'game participant' do

    before do
      @group.users << @user
      @game.players << @user
    end

    scenario 'leaves game from the group games page' do
      login @user
      visit group_games_path(@group)
      within('#game_' + @game.id.to_s) do
        click_link(t('games.game.leave'))
      end
      current_path.should eq(game_path(@game))
      page.find('#game .game_players').should have_no_content(@user.username)
    end

    scenario 'leaves game from the game page' do
      login @user
      visit game_path(@game)
      within('#game') do
        click_link(t('games.game.leave'))
      end
      current_path.should eq(game_path(@game))
      page.find('#game .game_players').should have_no_content(@user.username)
    end

  end

end
