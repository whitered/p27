require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Join Open Group" do

  background do
    @group = Group.make!(:private => false, :hospitable => true)
    @user = User.make!
    login @user
  end

  scenario 'user can join open group' do
    visit group_path(@group)
    click_link_or_button t('groups.show.join')
    page.should have_selector('#group_users')
    within('#group_users') do
      page.should have_content(@user.username)
    end
  end

end
