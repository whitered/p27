require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Set Group Admin" do

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
      @group.set_admin_status @admin, true
      login @user
    end

    scenario 'should be able to set group admin' do
      visit group_path(@group)
      find_member('Member').click_link_or_button t('groups.set_admin.link.name')
      find_member('Member').should have_selector('.admin')
    end

    scenario 'should be able to fire group admin' do
      visit group_path(@group)
      find_member('Admin').click_link_or_button t('groups.unset_admin.link.name')
      find_member('Admin').should have_no_selector('.admin')
    end
 
  end

end
