require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "View Games" do

  background do
    user = User.make!
    @group = Group.make!
    @games = Game.make!(3, :announcer => user, :group => @group)
    @group.games << @games
  end

  scenario 'view games' do
    visit group_path(@group)
    click_link t('groups.show.games')
    page.should have_selector('.games')
    gamelist = page.find('.games')
    @games.each do |game|
      gamelist.should have_content(game.description)
      gamelist.should have_content(game.place)
    end

  end

end
