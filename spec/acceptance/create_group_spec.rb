require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Create Group" do

  scenario 'user should be able to create new group' do
    login
    visit groups_path
    click_link t('groups.index.new_group')
    fill_in t('activerecord.attributes.group.name'), :with => 'Alpha Group'
    click_link_or_button t('groups.new.submit')
    page.should have_content('Alpha Group')
  end

  scenario 'group creator should become an admin' do
    login User.make!(:username => 'Bill_C')
    visit new_group_path
    fill_in t('activerecord.attributes.group.name'), :with => 'Alpha Group'
    click_link_or_button t('groups.new.submit')
    userlist = page.find('#group_users')
    userlist.should have_selector('.admin', :text => 'Bill_C')
  end

end
