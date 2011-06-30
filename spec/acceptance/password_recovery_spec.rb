require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Password Recovery' do

  background do
    @user = User.make!
  end

  scenario 'user recovers his password' do
    visit new_user_session_path
    click_link_or_button t('devise.sessions.new.new_password')
    fill_in t('activerecord.attributes.user.login'), :with => @user.username
    click_link_or_button t('devise.passwords.new.submit')

    mail = Capybara.string ActionMailer::Base.deliveries.last.body.to_s
    link = mail.first(:xpath, ".//a/@href[contains(., '#{edit_user_password_path}')]")
    visit link.text
    fill_in t('activerecord.attributes.user.password'), :with => 'new_password'
    fill_in t('activerecord.attributes.user.password_confirmation'), :with => 'new_password'
    click_link_or_button t('devise.passwords.edit.submit')

    page.should have_content(t('devise.passwords.updated'))
    page.should have_link(@user.username, :href => user_path(@user))
  end

end
