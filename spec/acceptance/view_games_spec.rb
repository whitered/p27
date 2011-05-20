require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "View Games" do

  background do
    user = User.make!
    @group = Group.make!
    @current_games = Game.make!(3, :announcer => user, :group => @group)
    @archive_game = Game.make!(:announcer => user, :group => @group, :archived => true)
    @group.games << @current_games << @archive_game
  end

  scenario 'view current games' do
    visit group_path(@group)
    within '#submenu' do
      click_link t('groups.show.games')
    end

    current_path.should == group_games_path(@group)
    within '#games' do
      @current_games.each do |game|
        page.should have_selector('article#game_' + game.id.to_s)
      end
    end
  end

  scenario 'view archive' do
    visit group_path(@group)
    within '#submenu' do
      click_link t('groups.show.archive')
    end

    current_path.should include(group_archive_path(@group))
    within '#games' do
      page.should have_selector('article#game_' + @archive_game.id.to_s)
    end
  end

end
