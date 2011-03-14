require 'spec_helper'

describe "groups/show.html.erb" do

  let(:page) { Capybara.string rendered }

  before do
    @user, @member, @admin = User.make!(3)
    @group = Group.make!
    @group.users << @user << @member << @admin
    @group.set_admin_status @admin, true
    sign_in @user
  end

  it 'should render group name' do
    render
    page.should have_content(@group.name)
  end

  it 'should render group users' do
    render
    page.should have_selector('#group_users')
  end

  describe '#group_users' do

    let(:group_users) { page.find('#group_users') }

    def find_user_item name
      group_users.find(:xpath, ".//li[contains(.,'#{name}')]")
    end

    it 'should render all the users' do
      render
      [@user, @admin, @member].each do |user|
        group_users.should have_link(user.username, :href => user_path(user.username))
      end
    end

    it 'should mark admins' do
      render

      group_users.should have_link(@member.username)
      group_users.should have_link(@admin.username)
      group_admins = group_users.find('.admin')
      group_admins.should have_content(@admin.username)
      group_admins.should have_no_content(@member.username)
    end

    context 'for a member' do

      it 'should not have invite_to_group form' do
        render
        page.should have_no_field(t('groups.manage_members.add.name'))
        page.should have_no_button(t('groups.manage_members.add.commit'))
      end

      it 'should not have links to set admin' do
        render
        group_users.should have_no_link(t('groups.manage_admins.set_link.name'))
      end

      it 'should not have links to unset admin' do
        render
        group_users.should have_no_link(t('groups.manage_admins.unset_link.name'))
      end

    end


    context 'for an admin' do

      before do
        @group.set_admin_status @user, true
      end

      it 'should have form to invite new users to the group' do
        render
        page.should have_field(t('groups.manage_members.add.name'))
        page.should have_button(t('groups.manage_members.add.commit'))
      end

      it 'should have links to remove any user from the group' do
        render
        group_users.all(:xpath, ".//a[. = '#{t('groups.manage_members.remove.link')}']").count.should eq(@group.users.count)
        group_users.all('li').each do |node|
          username = node.first('a').text
          node.should have_link(t('groups.manage_members.remove.link'), :href => manage_members_group_path(@group, :remove => username))
        end
      end

      it 'should not have links to set admin' do
        render
        group_users.should have_no_link(t('groups.manage_admins.set_link.name'))
      end

      it 'should not have links to unset admin' do
        render
        group_users.should have_no_link(t('groups.manage_admins.unset_link.name'))
      end

   end

    context 'for owner' do

      before do
        @group.owner = @user
      end

      it 'should have links to set admin for regular members' do
        render
        find_user_item(@member.username).should have_link(t('groups.manage_admins.set_link.name'), :href => manage_admins_group_path(@group, :set => @member.username))
      end

      it 'should have links to unset admin for admins' do
        render
        find_user_item(@admin.username).should have_link(t('groups.manage_admins.unset_link.name'), :href => manage_admins_group_path(@group, :unset => @admin.username))
      end

      it 'should not have link to set admin for admin' do
        render
        find_user_item(@admin.username).should have_no_link(t('groups.manage_admins.set_link.name'))
      end

      it 'should not have link to unset admin for regular member' do
        render
        find_user_item(@member.username).should have_no_link(t('groups.manage_admins.unset_link.name'))
      end


    end

  end

end
