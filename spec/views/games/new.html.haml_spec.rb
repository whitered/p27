require 'spec_helper'

describe "games/new.html.haml" do

  before do
    @group = Group.make!
    @game = Game.new(:date => Date.tomorrow)
  end

  let(:page) { Capybara.string rendered }

  def content_for name
    view.instance_variable_get(:@_content_for)[name]
  end

  it 'should have fields for game date' do
    render
    page.should have_field(t('activerecord.attributes.game.date'))
  end

  it 'should have link to group in title prefix' do
    render
    prefix = Capybara.string(content_for(:title_prefix))
    prefix.should have_link(@group.name, :href => group_path(@group))
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

  it 'should have field for buyin' do
    render
    page.should have_field(t('activerecord.attributes.game.buyin'))
  end

  it 'should have field for rebuy' do
    render
    page.should have_field(t('activerecord.attributes.game.rebuy'))
  end

  it 'should have field for addon' do
    render
    page.should have_field(t('activerecord.attributes.game.addon'))
  end

  it 'should have submit button' do
    render
    page.should have_button(t('games.new.submit'))
  end
end
