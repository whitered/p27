require 'spec_helper'

describe "groups/show.html.erb" do

  let(:page) { Capybara.string rendered }
  let(:group_users) { page.find('#group_users') }

  before do
    @group = Group.make!
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

    it 'should render all the users' do
      names = %w( John Mark Bob )
      names.each { |name| @group.users.create(:username => name) }
      render
      names.each do |name|
        group_users.should have_link(name, :href => user_path(name))
      end
    end

    it 'should mark admins' do
      member, admin = User.make!(2)
      @group.users << member << admin
      @group.set_admin_status admin, true

      render

      group_users.should have_link(member.username)
      group_users.should have_link(admin.username)
      group_admins = group_users.find('.admin')
      group_admins.should have_content(admin.username)
      group_admins.should have_no_content(member.username)
    end

  end

end
