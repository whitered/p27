require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Add User To Group" do

  context 'group admin' do

    before do
      @group = Group.make!
      @admin = User.make!
      @users = User.make!(3)
      @group.users << @admin
      @group.set_admin_status @admin, true
      login @admin
    end

    scenario 'should be able to add several users to the group by their usernames' do
      visit group_path(@group.id)
      fill_in t('groups.add_user.name'), :with => @users.map{ |u| u.username }.join(' ')
      click_link_or_button t('groups.add_user.commit')

      group_members = page.find('#group_users')
      @users.each do |user|
        group_members.should have_link(user.username, :href => user_path(user.username))
      end

    end
  end

end
