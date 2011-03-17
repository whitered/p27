require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Edit Group' do

  scenario 'group owner can edit group' do
    visit edit_group_path(@group)
    fill_in t('activerecord.attributes.group.name'), :with => 'This is new name'
    check t('activerecord.attributes.group.private')
    check t('activerecord.attributes.group.hospitable')
    click_link_or_button t('groups.edit.commit')

    visit edit_group_path(@group)
    page.should have_content(t('groups.edit.successful'))
    page.find_field(t('activerecord.attributes.group.name')).value.should eq('This is new name')
    page.find_field(t('activerecord.attributes.group.private')).should be_checked
    page.find_field(t('activerecord.attributes.group.hospitable')).should be_checked

  end
end
