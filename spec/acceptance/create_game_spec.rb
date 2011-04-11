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
    datetime = Date.today + 1
    datetime.time = Time.new('21:00')
    fill_in t('activerecord.attributes.game.date'), :with => datetime.date
    fill_in t('activerecord.attributes.game.time'), :with => datetime.time
    fill_in t('activerecord.attributes.game.description'), :with => 'New Year Tourney'
    fill_in t('activerecord.attributes.game.place'), :with => 'Blogistan'
    click_link_or_button t('games.new.commit')
    game = page.find('#game')
    game.should have_content('New Year Tourney')
    game.should have_content('Blogistan')
    game.should have_content(l(datetime))
  end

end
