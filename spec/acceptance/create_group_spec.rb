require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Create Group" do

  scenario 'user should be able to create new group' do
    login
    visit root_path
    click_link t('groups.new.link')
    fill_in t('activerecord.attributes.group.name'), :with => 'Alpha Group'
    click_link_or_button t('group.new.sibmit')
    page.should have_content(t('group.new.successful'))
    page.should have_content('Alpha Group')
  end

end
