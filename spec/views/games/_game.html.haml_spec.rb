require 'spec_helper'

describe 'games/_game.html.haml' do

  before do
    stub_template 'users/_user.html.haml' => '= user.username'
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

  it 'should render game description' do
    do_render
    page.should have_content(@game.description)
  end

  it 'should render game place' do
    do_render
    page.should have_content(@game.place)
  end

  it 'should render game announcer' do
    do_render
    page.should have_content(@game.announcer.username)
  end

  it 'should render _user template for announcer' do
    do_render
    page.should render_template('users/_user')
  end

  it 'should render game date' do
    do_render
    page.should have_content(l(@game.date))
  end

  it 'should have link to game page' do
    do_render
    page.should have_xpath(".//a[@href = '#{game_path(@game)}']")
  end

  context 'for group member' do

    before do
      user = User.make!
      @game.group.users << user
      sign_in user
    end

    it 'should have link to join game' do
      do_render
      page.should have_link(t('games.game.join'), :href => join_game_path(@game), :method => :post)
    end

  end
end
