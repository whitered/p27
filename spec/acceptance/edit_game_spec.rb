require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Edit Game' do

  background do
    @user = User.make!
    @group = Group.make!
    @game = Game.make!(:announcer => @user, :group => @group)
  end

  context 'game creator' do

    before do
      login @user
    end

    scenario 'sets cash game' do
      visit game_path(@game)
      click_link t('games.show.edit')
      select(t('activerecord.attributes.game.type.cash'), :from => t('activerecord.attributes.game.type'))
      click_link_or_button t('games.edit.submit')
      current_path.should eq(games_path(@game))
      within('#game') do
        page.should have_content(t('activerecord.attributes.game.type.cash'))
      end
    end

    scenario 'sets tourney' do
      visit edit_game_path(@game)
      select(t('activerecord.attributes.game.type.tourney'), :from => t('activerecord.attributes.game.type'))
      fill_in t('activerecord.attributes.game.buyin'), :with => '200'
      click_link_or_button t('games.edit.submit')
      current_path.should eq(games_path(@game))
      within('#game') do
        page.should have_content(t('activerecord.attributes.game.type.tourney'))
        page.should have_content(t('activerecord.attributes.game.buyin'))
        page.should have_content('200')
      end
    end

    scenario 'sets tourney with rebuys' do
      visit edit_game_path(@game)
      select(t('activerecord.attributes.game.type.tourney_with_rebuys'), :from => t('activerecord.attributes.game.type'))
      fill_in t('activerecord.attributes.game.buyin'), :with => '150'
      fill_in t('activerecord.attributes.game.rebuy'), :with => '200'
      fill_in t('activerecord.attributes.game.addon'), :with => '400'
      click_link_or_button t('games.edit.submit')
      current_path.should eq(games_path(@game))
      within('#game') do
        [
          t('activerecord.attributes.game.type.tourney_with_rebuys'),
          t('activerecord.attributes.game.buyin'),
          '150',
          t('activerecord.attributes.game.rebuy'),
          '200',
          t('activerecord.attributes.game.addon'),
          '400'
        ].each do |content|
          page.should have_content(content)
        end
      end

    end
  end
end
