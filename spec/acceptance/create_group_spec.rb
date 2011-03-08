require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Create Group" do

  scenario 'user should be able to create new group' do
    login
    visit root_path
    click_link t('groups.new.link')
    fill_in t('activerecord.attributes.group.name'), :with => 'Alpha Group'
    click_link_or_button t('groups.new.submit')
    page.should have_content('Alpha Group')
  end

end
