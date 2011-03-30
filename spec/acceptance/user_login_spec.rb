require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "User Login" do

  def try_login login, password
    visit new_user_session_path
    fill_in t('activerecord.attributes.user.login'), :with => login
    fill_in t('activerecord.attributes.user.password'), :with => password
    click_link_or_button t('devise.sessions.new.commit')
  end

  let(:user) { User.make!(:confirmed_at => nil) }

  context 'confirmed user' do

    before(:each) do
      user.update_attribute(:confirmed_at, Date.today - 1)
    end

    scenario 'should be able to login with username' do
      try_login user.username, user.password
      page.should have_content(t('devise.sessions.signed_in'))
    end
    
    scenario 'should be able to login with email' do
      try_login user.email, user.password
      page.should have_content(t 'devise.sessions.signed_in')
    end

    scenario 'should not be able to login with wrong password' do
      try_login user.email, 'wrong_password'
      page.should have_no_content(t 'devise.sessions.signed_in')
      page.should have_content(t 'devise.failure.invalid')
    end

    scenario 'should not be able to login with wrong login' do
      try_login 'wrong_login', user.password
      page.should have_no_content(t 'devise.sessions.signed_in')
      page.should have_content(t 'devise.failure.invalid')
    end

  end


  context 'not confirmed user' do

    scenario 'should not be able to login with username' do
      try_login user.username, user.password
      page.should have_content(t 'devise.failure.unconfirmed')
    end

    scenario 'should not be able to login with email' do
      try_login user.email, user.password
      page.should have_content(t 'devise.failure.unconfirmed')
    end

  end

end
