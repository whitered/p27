require 'spec_helper'

describe "users/show.html.haml" do

  let(:page) { Capybara.string rendered }

  let(:submenu) { Capybara.string view.instance_variable_get(:@_content_for)[:submenu] }

  before do
    @user = User.make
  end

  #it 'should contain username' do
    #render
    #page.should have_content(@user.username)
  #end

  it 'should have link to edit profile page if user is logged in' do
    sign_in @user
    render
    submenu.should have_link(t('users.show.edit_profile'), :href => edit_user_registration_path)
  end

  it 'should have user name' do
    @user.update_attribute(:name, 'Bill C')
    render
    page.should have_content(@user.name)
  end

end
