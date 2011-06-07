require 'spec_helper'

describe 'games/edit.html.haml' do

  before do
    @game = Game.make!(:announcer => User.make!, :group => Group.make!)
  end

  let(:page) { Capybara.string rendered }

  it 'should have field for description' do
    render
    page.should have_field(t('activerecord.attributes.game.description'))
  end

  it 'should have field for date' do
    render
    page.should have_field(t('activerecord.attributes.game.date'))
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

  it 'should have archived checkbox' do
    render
    page.should have_field(t('activerecord.attributes.game.archived'))
  end

  it 'should have submit button' do
    render
    page.should have_button(t('games.edit.submit'))
  end

  it 'should have fields for each participation' do
    @game.update_attributes(:buyin => 200, :rebuy => 100)
    @game.players << User.make!(2)
    render
    @game.participations.each_with_index do |participation, i|
      selector = '#participation_' + participation.id.to_s
      page.should have_selector(selector)
      node = page.find(selector)
      node.should have_field("game_participations_attributes_#{i}_rebuys")
      node.should have_field("game_participations_attributes_#{i}_addon")
      node.should have_field("game_participations_attributes_#{i}_win")
    end
  end

  it 'should have field for dummy name' do
    render
    page.should have_field(t('activerecord.attributes.participation.dummy_name'))
  end

  it 'should have button to add dummy' do
    render
    page.should have_button(t('games.edit.add_dummy'))
  end
end
