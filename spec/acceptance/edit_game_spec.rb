require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Edit Game' do

  background do
    @user = User.make!
    @group = Group.make!
    @group.users << @user
    @game = Game.make!(:announcer => @user, :group => @group)
  end

  context 'game creator' do

    before do
      login @user
    end

    scenario 'sets cash game' do
      visit game_path(@game)
      click_link t('games.show.edit')
      click_link_or_button t('games.edit.submit')
      current_path.should eq(game_path(@game))
      within('#game') do
        page.should have_content(t('activerecord.attributes.game.type.cash'))
      end
    end

    scenario 'sets tourney' do
      visit edit_game_path(@game)
      fill_in t('activerecord.attributes.game.buyin'), :with => '200'
      click_link_or_button t('games.edit.submit')
      current_path.should eq(game_path(@game))
      within('#game') do
        page.should have_content(t('activerecord.attributes.game.type.tourney'))
        title = t('activerecord.attributes.game.buyin')
        page.should have_xpath(".//span[@title='#{title}' and .='200']")
      end
    end

    scenario 'sets tourney with rebuys' do
      visit edit_game_path(@game)
      fill_in t('activerecord.attributes.game.buyin'), :with => '150'
      fill_in t('activerecord.attributes.game.rebuy'), :with => '200'
      fill_in t('activerecord.attributes.game.addon'), :with => '400'
      click_link_or_button t('games.edit.submit')
      current_path.should eq(game_path(@game))
      page.should have_content(t('activerecord.attributes.game.type.tourney_with_rebuys'))
      within('#game') do
        [
          [t('activerecord.attributes.game.buyin'), '150'],
          [t('activerecord.attributes.game.rebuy'), '200'],
          [t('activerecord.attributes.game.addon'), '400']
        ].each do |title, value|
          page.should have_xpath(".//span[@title='#{title}' and .='#{value}']")
        end
      end
    end

    scenario 'adds fake player' do
      visit edit_game_path(@game)
      fill_in t('activerecord.attributes.participation.dummy_name'), :with => 'Obama'
      click_link_or_button t('games.edit.add_dummy')
      page.find('form.game').should have_content('Obama')
    end

  end

  context 'in game with some registered players' do

    before do 
      @game.update_attribute :buyin, 100
      @game.players << User.make!(3)
      login @user
    end

    scenario 'enter game results' do
      visit edit_game_path(@game)
      check t('activerecord.attributes.game.archived')
      within '#user_' + @game.players.first.id.to_s do
        fill_in 'game_participations_attributes_0_win', :with => 250
      end
      within '#user_' + @game.players.second.id.to_s do
        fill_in 'game_participations_attributes_1_win', :with => 50
      end
      click_link_or_button t('games.edit.submit')
      current_path.should eq(game_path(@game))
      within '#players' do
        within '#user_' + @game.players.first.id.to_s do
          page.should have_content('250')
        end
        within '#user_' + @game.players.second.id.to_s do
          page.should have_content('50')
        end
      end
    end

    scenario 'archieves game' do
      visit edit_game_path(@game)
      check t('activerecord.attributes.game.archived')
      click_link_or_button t('games.edit.submit')
      current_path.should eq(game_path(@game))
      page.should have_selector('#game.archived')
      page.find('#game').should have_content(t('games.show.archived'))
    end
  end
end
