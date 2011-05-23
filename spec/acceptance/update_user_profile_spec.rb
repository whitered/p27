require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Update User Profile' do

  background do
    @user = User.make!(:password => 'secret', :password_confirmation => 'secret')
    login @user
  end

  scenario 'user updates his email' do
    visit user_path(@user)
    click_link t('users.show.edit_profile')
    fill_in t('activerecord.attributes.user.email'), :with => 'new_email@server.com'
    fill_in t('activerecord.attributes.user.current_password'), :with => 'secret'
    click_link_or_button t('registrations.edit.submit')

    current_path.should == user_path(@user)
    page.should have_content(t('devise.registrations.updated'))

    visit edit_user_registration_path(@user)
    page.should have_field(t('activerecord.attributes.user.email'), :with => 'new_email@server.com')
  end

  scenario 'user updates his password' do
    visit edit_user_registration_path
    fill_in t('activerecord.attributes.user.password'), :with => 'new_password'
    fill_in t('activerecord.attributes.user.password_confirmation'), :with => 'new_password'
    fill_in t('activerecord.attributes.user.current_password'), :with => 'secret'
    click_link_or_button t('registrations.edit.submit')

    current_path.should == user_path(@user)
    page.should have_content(t('devise.registrations.updated'))
  end

end
