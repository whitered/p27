require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Manage Group Admins' do

  context 'group admin' do

    def find_member name
      group_users = page.find '#group_users'
      group_users.find(:xpath, ".//li[contains(.,'#{name}')]")
    end

    before do
      @group = Group.make!
      @user, @admin, @member = User.make!(3)
      @group.users << @user << @admin << @member
      @group.owner = @user
      @group.save!
      @group.set_admin_status @admin, true
      login @user
    end

    scenario 'should be able to set group admin' do
      visit group_path(@group)
      find_member(@member.username).click_link_or_button t('groups.set_admin.set_link.name')
      find_member(@member.username).should have_selector('.admin')
    end

    scenario 'should be able to unset group admin' do
      visit group_path(@group)
      find_member(@admin.username).click_link_or_button t('groups.set_admin.unset_link.name')
      find_member(@admin.username).should have_no_selector('.admin')
    end
 
  end

end
