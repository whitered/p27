require 'spec_helper'

describe "games/new.html.haml" do

  before do
    @group = Group.make!
    @game = Game.new
  end

  let(:page) { Capybara.string rendered }

  it 'should have fields for game date' do
    render
    page.should have_field(t('activerecord.attributes.game.date'))
  end

  #it 'should have fields for game time' do
    #render
    #page.should have_field(t('activerecord.attributes.game.time'))
  #end

  it 'should have field for game description' do
    render
    page.should have_field(t('activerecord.attributes.game.description'))
  end

  it 'should have field for game place' do
    render
    page.should have_field(t('activerecord.attributes.game.place'))
  end

  it 'should have submit button' do
    render
    page.should have_button(t('games.new.submit'))
  end
end
