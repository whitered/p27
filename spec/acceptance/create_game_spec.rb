require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Create Game' do

  background do
    @group = Group.make!
    @user = User.make!
    @user.groups << @group
  end

  scenario 'create game' do
    login @user
    visit group_path(@group)
    click_link_or_button t('groups.show.new_game')
    fill_in t('activerecord.attributes.game.date'), :with => "2011-05-25 21:33"
    fill_in t('activerecord.attributes.game.description'), :with => 'New Year Tourney'
    fill_in t('activerecord.attributes.game.place'), :with => 'Blogistan'
    click_link_or_button t('games.new.submit')
    game = page.find('#game')
    game.should have_content('New Year Tourney')
    game.should have_content('Blogistan')
  end

end
