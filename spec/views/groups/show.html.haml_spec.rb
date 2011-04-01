require 'spec_helper'

describe "groups/show.html.haml" do

  let(:page) { Capybara.string rendered }

  before do
    stub_template 'posts/_post' => '<div class="stub_template_post"/>'
    stub_template 'users/_user' => '<div class="stub_template_user"><%= user.username %></div>'
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
        group_users.should have_xpath(".//*[@class = 'stub_template_user' and . = '#{user.username}']")
      end
    end

    it 'should mark admins' do
      render

      group_users.should have_content(@member.username)
      group_users.should have_content(@admin.username)
      group_admins = group_users.find('.admin')
      group_admins.should have_content(@admin.username)
      group_admins.should have_no_content(@member.username)
    end

    context 'for a member' do

      it 'should not have links to set admin' do
        render
        group_users.should have_no_link(t('groups.show.set_admin'))
      end

      it 'should not have links to unset admin' do
        render
        group_users.should have_no_link(t('groups.show.unset_admin'))
      end

      it 'should have link to leave group' do
        render
        group_users.should have_link(t('groups.show.leave'), :href => leave_group_path(@group))
      end

      it 'should not have link to join group' do
        render
        group_users.should have_no_link(t('groups.show.join'))
      end

    end


    context 'for an admin' do

      before do
        @group.set_admin_status @user, true
      end

      it 'should have links to remove any user from the group' do
        render
        group_users.all(:xpath, ".//a[. = '#{t('groups.show.remove_member')}']").count.should eq(@group.users.count)
        group_users.all('li').each do |node|
          username = node.first('.stub_template_user').text
          node.should have_link(t('groups.show.remove_member'), :href => remove_member_group_path(@group, :username => username))
        end
      end

      it 'should not have links to set admin' do
        render
        group_users.should have_no_link(t('groups.show.set_admin'))
      end

      it 'should not have links to unset admin' do
        render
        group_users.should have_no_link(t('groups.show.unset_admin'))
      end

      it 'should have link to leave group' do
        render
        group_users.should have_link(t('groups.show.leave'), :href => leave_group_path(@group))
      end

      it 'should have link to the new invitation page' do
        render
        group_users.should have_link(t('groups.show.new_invitation'), :href => new_group_invitation_path(@group))
      end

    end

    context 'for owner' do

      before do
        @group.owner = @user
      end

      it 'should have links to set admin for regular members' do
        render
        find_user_item(@member.username).should have_link(t('groups.show.set_admin'), :href => manage_admins_group_path(@group, :set => @member.username))
      end

      it 'should have links to unset admin for admins' do
        render
        find_user_item(@admin.username).should have_link(t('groups.show.unset_admin'), :href => manage_admins_group_path(@group, :unset => @admin.username))
      end

      it 'should not have link to set admin for admin' do
        render
        find_user_item(@admin.username).should have_no_link(t('groups.show.set_admin'))
      end

      it 'should not have link to unset admin for regular member' do
        render
        find_user_item(@member.username).should have_no_link(t('groups.show.unset_admin'))
      end


    end

    context 'for guest' do
      before do
        @group.users.delete @user
      end

      it 'should not have leave link' do
        render
        group_users.should have_no_link(t('groups.show.leave'))
      end

      context 'hospitable group' do

        before do
          @group.update_attribute(:hospitable, true)
        end

        it 'should have link to join group' do
          render
          group_users.should have_link(t('groups.show.join'), :href => join_group_path(@group))
        end

      end

      context 'not hospitable group' do

        before do
          @group.update_attribute(:hospitable, false)
        end

        it 'should not have link to join group' do
          render
          group_users.should have_no_link(t('groups.show.join'))
        end

      end
    end

  end


  it 'should show edit link for group owner' do
    @group.update_attribute(:owner_id, @user.id)
    render
    page.should have_link(t('groups.show.edit', :href => edit_group_path(@group)))
  end

  it 'should not show edit link for admin' do
    @group.set_admin_status @user, true
    render
    page.should have_no_link(t('groups.show.edit'))
  end

  it 'should not show edit link for guest' do
    @group.users.delete @user
    render
    page.should have_no_link(t('groups.show.edit'))
  end

  it 'should render group posts' do
    3.times { Post.make!(:group => @group, :author => User.make!) }
    render
    page.should have_selector('#posts')
    page.all('#posts .stub_template_post').size.should eq(3)
  end

  it 'should have new post link for authorized user' do
    @group.set_admin_status @user, true
    render
    page.should have_link(t('groups.show.new_post'), :href => new_group_post_path(@group))
  end
    
  it 'should not have new post link for not authorized user' do
    @group.users.delete @user
    render
    page.should have_no_link(t('groups.show.new_post'))
    page.should have_no_xpath("//a[@href = '#{new_group_post_path(@group)}']")
  end
end
