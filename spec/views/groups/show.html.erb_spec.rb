require 'spec_helper'

describe "groups/show.html.erb" do

  let(:page) { Capybara.string rendered }
  let(:group_users) { page.find_selector('#group_users') }

  before do
    @group = Group.make
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
      names.each { |name| @group.users << User.make(:username => name) }
      render
      names.each do |name|
        group_users.should have_link(name)
      end
    end

    it 'should mark admins' do
      @group.users << User.make(:username => 'Bob')
      @group.admins << User.make(:username => 'Ivan')
      render
      group_users.should have_link('Bob')
      group_users.should have_link('Ivan')
      group_admins = group_users.find_selector('.admin')
      group_admins.should have_content('Ivan')
      group_admins.should have_no_content('Bob')
    end

  end

end
