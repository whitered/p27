require 'spec_helper'

describe "games/show.html.haml" do

  before do
    stub_template 'users/_user.html.haml' => '= user.username'
    @game = Game.make!(:announcer => User.make!, :group => Group.make!)
  end

  let(:page) { Capybara.string rendered }

  it 'should have #game selector' do
    render
    page.should have_selector('#game')
  end

  it 'should have game date' do
    render
    page.should have_content(l(@game.date))
  end

  it 'should have game description' do
    render
    page.should have_content(@game.description)
  end

  it 'should have game place' do
    render
    page.should have_content(@game.place)
  end

  it 'should have link to group' do
    render
    page.should have_link(@game.group.name, :href => group_path(@game.group))
  end

  it 'should render game players' do
    @game.users << User.make!(3)
    render
    page.should have_selector('.game_players')
    game_players = page.find('.game_players')
    @game.users.each do |user|
      game_players.should have_content(user.username)
    end
  end

  it 'should render game announcer' do
    render
    page.should have_content(@game.announcer.username)
  end

  it 'should render link to edit game if user authorized to' do
    @game.group.users << @game.announcer
    sign_in @game.announcer
    render
    page.should have_link(t('games.show.edit'), :href => edit_game_path(@game))
  end

  it 'should not render link to edit game for not authorized user' do
    render
    page.should have_no_link(t('games.show.edit'))
    page.should have_no_xpath(".//a[@href = '#{edit_game_path(@game)}']")
  end
end
