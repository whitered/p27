require 'spec_helper'

describe "users/show.html.haml" do

  let(:page) { Capybara.string rendered }

  let(:submenu) { Capybara.string view.instance_variable_get(:@_content_for)[:submenu] }

  before do
    @user = User.make!
  end

  def content_for name
    view.instance_variable_get(:@_content_for)[name]
  end

  it 'should contain username in page title' do
    render
    content_for(:title).should include(@user.username)
  end

  context 'for own profile' do

    before do
      sign_in @user
    end
  
    it 'should have link to edit profile page' do
      render
      submenu.should have_link(t('users.show.edit_profile'), :href => edit_user_registration_path)
    end

    it 'should have link to invitations index' do
      render
      submenu.should have_link(t('users.show.invitations'), :href => invitations_path)
    end

  end

  context 'for foreign profile' do

    before do
      sign_in User.make!
    end

    it 'should not have link to edit profile' do
      render
      submenu.should have_no_link(t('users.show.edit_profile'))
      submenu.should have_no_xpath(".//a[@href='#{edit_user_registration_path}']")
    end

    it 'should not have link ot invitations path' do
      render
      submenu.should have_no_link(t('users.show.invitations'))
      submenu.should have_no_xpath(".//a[@href='#{invitations_path}']")
    end

  end

  it 'should have user name' do
    @user.update_attribute(:name, 'Bill C')
    render
    page.should have_content(@user.name)
  end

end
