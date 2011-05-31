require 'spec_helper'

describe 'games/_game_type.html.haml' do

  before do
    @game = Game.make
  end

  let(:page) { Capybara.string rendered }

  context 'for cash' do

    before do
      render 'games/game_type', :game => @game
    end

    it 'should render game type' do
      page.should have_content(t('activerecord.attributes.game.type.cash'))
    end

  end

  context 'for tourney' do

    before do
      @game.buyin = 100
      render 'games/game_type', :game => @game
    end

    it 'should render game type' do
      page.should have_content(t('activerecord.attributes.game.type.tourney'))
    end

    it 'should render buyin value' do
      title = t('activerecord.attributes.game.buyin')
      page.should have_xpath(".//span[@title = '#{title}' and .='100']")
    end

  end

  context 'for tourney with rebuys' do

    before do
      @game.buyin = 100
      @game.rebuy = 200
      @game.addon = 300
      render 'games/game_type', :game => @game
    end

    it 'should render game_type' do
      page.should have_content(t('activerecord.attributes.game.type.tourney_with_rebuys'))
    end

    it 'should render buyin value' do
      title = t('activerecord.attributes.game.buyin')
      page.should have_xpath(".//span[@title='#{title}' and .='100']")
    end

    it 'should render rebuy value' do
      title = t('activerecord.attributes.game.rebuy')
      page.should have_xpath(".//span[@title='#{title}' and .='200']")
    end

    it 'should render addon value' do
      title = t('activerecord.attributes.game.addon')
      page.should have_xpath(".//span[@title='#{title}' and .='300']")
    end
  end
end
