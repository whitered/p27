require 'spec_helper'

describe 'games/index.html.haml' do

  before do
    stub_template 'games/_game.html.haml' => '.game= game.id'
    @games = Game.make!(3, :announcer => User.make!, :group => Group.make!)
  end

  let(:page) { Capybara.string rendered }

  it 'should have page title' do
    render
    page.should have_content(t('games.index.title'))
  end

  it 'should have archive title in archive' do
    params[:archive] = true
    render
    page.should have_content(t('games.index.archive_title'))
  end

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
end
