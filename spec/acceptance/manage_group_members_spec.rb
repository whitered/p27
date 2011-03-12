require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Manage Group Members' do

  context 'group admin' do

    before do
      @group = Group.make!
      @admin = User.make!
      @group.users << @admin
      @group.set_admin_status @admin, true
      login @admin
    end

    let(:group_users) { page.find '#group_users' }

    scenario 'should be able to add several users to the group by their usernames' do
      users = User.make!(3)
      visit group_path(@group)
      fill_in t('groups.add_user.name'), :with => users.map{ |u| u.username }.join(' ')
      click_link_or_button t('groups.add_user.commit')

      users.each do |user|
        group_users.should have_link(user.username, :href => user_path(user.username))
      end

    end

    scenario 'should be able to remove user from group' do
      member = User.make!
      @group.users << member

      visit group_path(group)
      within '#group_users' do
        within(:xpath, ".//li[contains(.,'#{member.username}')]") do
          click_link_or_button t('groups.remove_user.link')
        end
      end

      group_users.should have_no_content(member.username)
      page.should have_content(t('groups.remove_user.successful', :username => member.username))
    end

  end
 end
