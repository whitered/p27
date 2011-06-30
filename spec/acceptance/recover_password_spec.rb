require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Recover Password' do

  let(:user) { User.make! }

  def do_recover login
    visit new_user_password_path
    fill_in t('activerecord.attributes.user.login'), :with => login
    click_link_or_button t('devise.passwords.new.submit')
  end
 

  scenario 'should be able to recover password by username' do
    do_recover user.username
    page.should have_content(t('devise.passwords.send_instructions'))
  end


  scenario 'should be able to recover password by email' do
    do_recover user.email
    page.should have_content(t('devise.passwords.send_instructions'))
  end


  scenario 'should send instructions to email' do
    lambda do
      do_recover user.email
    end.should change(ActionMailer::Base.deliveries, :count).by(1)
    user.reload
    mail = ActionMailer::Base.deliveries.last
    body = Capybara.string mail.body.raw_source
    body.should have_content(user.username)
    href = edit_user_password_url(:reset_password_token => user.reset_password_token,
                                  :host => ActionMailer::Base.default_url_options[:host])
    body.should have_xpath(".//a[@href = '#{href}']")
  end

end
