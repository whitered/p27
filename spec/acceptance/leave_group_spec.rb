require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Leave Group' do

  background do
    @group = Group.make!
    @user = User.make!
    @group.users << @user
    login @user
  end


  scenario 'group member leaves public group' do
    @group.update_attribute(:private, false)
    visit group_path(@group)
    click_link_or_button t('groups.show.leave')
    current_path.should == root_path
    page.should have_content(t('memberships.destroy.leave_successful', :group => @group.name))
    visit group_path(@group)
    page.find('#group_users').should have_no_content(@user.username)
  end

  scenario 'group members leaves private group' do
    @group.update_attribute(:private, true)
    visit group_path(@group)
    click_link_or_button t('groups.show.leave')
    page.should have_content(t('memberships.destroy.leave_successful', :group => @group.name))
  end
end
