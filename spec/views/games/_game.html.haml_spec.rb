require 'spec_helper'

describe 'games/_game.html.haml' do

  before do
    stub_template 'users/_user.html.haml' => '= user.username'
    @game = Game.make!(:announcer => User.make!, :group => Group.make!)
    render :partial => 'games/game', :locals => { :game => @game }
  end

  let(:page) { Capybara.string rendered }

  it 'should have class game' do
    page.should have_selector('.game')
  end

  it 'should render game description' do
    page.should have_content(@game.description)
  end

  it 'should render game place' do
    page.should have_content(@game.place)
  end

  it 'should render game announcer' do
    page.should have_content(@game.announcer.username)
  end

  it 'should render _user template for announcer' do
    page.should render_template('users/_user')
  end

  it 'should render game date' do
    page.should have_content(l(@game.date))
  end
end
