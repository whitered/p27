require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "View Games Index" do
  
  background do
    @public_group = Group.make!
    @private_group = Group.make!(:private => true)
    @public_group.games << Game.make(2, :announcer => User.make!)
    @private_group.games << Game.make(:announcer => User.make!)
  end

  scenario 'view public games' do
    visit games_path
    @public_group.games.each do |game|
      page.should have_content(game.place)
    end
    @private_group.games.each do |game|
      page.should have_no_content(game.place)
    end
  end

end
