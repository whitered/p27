require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "View Games Index" do
  
  background do
    public_group = Group.make!
    private_group = Group.make!(:private => true)
    @games = Game.make(4, :announcer => User.make!)
    @games[0].archived = true
    public_group.games << @games[0..1]
    private_group.games << @games[2]
  end

  scenario 'view public games' do
    visit games_path
    page.should have_content(@games[1].place)
    [0, 2].map { |n| @games[n] }.each do |game|
      page.should have_no_content(game.place)
    end
  end

end
