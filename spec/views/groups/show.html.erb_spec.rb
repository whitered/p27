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
        page.should have_no_field(t('groups.add_user.name'))
        page.should have_no_button(t('groups.add_user.commit'))
      end
    end

    context 'for an admin' do

      before do
        @group.set_admin_status @user, true
      end

      it 'should have form to invite new users to the group' do
        render
        page.should have_field(t('groups.add_user.name'))
        page.should have_button(t('groups.add_user.commit'))
      end

    end

  end

end
