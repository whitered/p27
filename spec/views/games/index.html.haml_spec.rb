require 'spec_helper'

describe 'games/index.html.haml' do

  before do
    stub_template 'games/_game.html.haml' => '.game= game.id'
    @games = Game.make!(3, :announcer => User.make!, :group => Group.make!)
  end

  let(:page) { Capybara.string rendered }

  it 'should have #games selector' do
    render
    page.should have_selector('#games')
  end

  it 'should render _game partial for each game in the collection' do
    render
    @games.each do |game|
      page.find('#games').should have_xpath(".//*[@class = 'game' and . = '#{game.id}']")
    end
  end

  describe 'sidebar' do
    
    let(:sidebar) { Capybara.string view.instance_variable_get(:@_content_for)[:sidebar] }

    context 'when @group is defined and user is authenticated to announce games' do

      before do
        @group = @games.first.group
        user = User.make!
        @group.users << user
        sign_in user
      end

      it 'should have link to create new game' do
        render
        sidebar.should have_link(t('games.index.new_game'), :href => new_group_game_path(@group))
      end
    end
  end
end
