require 'spec_helper'

describe "games/show.html.haml" do

  before do
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
end
