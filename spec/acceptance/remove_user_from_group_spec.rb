require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Remove User From Group" do

  context 'group admin' do

    scenario 'should be able to remove user from group' do
      group = Group.make!
      admin, user, victim = User.make!(3)
      group.users << admin << user << victim
      group.set_admin_status admin, true
      login admin

      visit group_path(group)
      within '#group_users' do
        within(:xpath, ".//li[contains(.,'#{victim.username}')]") do
          click_link_or_button t('groups.remove_user.link')
        end
      end

      group_members = page.find('#group_users')
      group_members.should have_no_content(victim.username)
      page.should have_content(t('groups.remove_user.successful', :username => victim.username))
    end

  end

end
