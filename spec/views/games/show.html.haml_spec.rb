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
end
