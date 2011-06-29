require 'spec_helper'

describe 'games/_game' do

  before do
    stub_template 'shared/_date.html.slim' => '= date.to_s'
    stub_template 'users/_user.html.slim' => '= user.username'
    stub_template 'games/_game_type.html.slim' => 'div class="game_type"'
    @game = Game.make!(:announcer => User.make!, :group => Group.make!)
  end

  def do_render
    render :partial => 'games/game', :locals => { :game => @game }
  end

  let(:page) { Capybara.string rendered }

  it 'should have class and id of the game' do
    do_render
    page.should have_selector('.game#game_' + @game.id.to_s)
  end

  it 'should render game_type' do
    do_render
    page.should have_selector('div.game_type')
  end

  it 'should render game place' do
    do_render
    page.should have_content(@game.place)
  end

  it 'should render game date' do
    do_render
    page.should have_content(@game.date.to_s)
  end

  it 'should have link to game page' do
    do_render
    page.should have_xpath(".//a[@href = '#{game_path(@game)}']")
  end

end
