require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "User Registration Confirmation" do

  context 'just registered user' do

     def do_register
      visit new_user_registration_path
      fill_in t('activerecord.attributes.user.username'), :with => 'john'
      fill_in t('activerecord.attributes.user.email'), :with => 'john@mail.com'
      fill_in t('activerecord.attributes.user.password'), :with => 'qwerty'
      fill_in t('activerecord.attributes.user.password_confirmation'), :with => 'qwerty'
      click_link_or_button t('registrations.new.submit')
    end


    def john
      User.find_by_username('john')
    end


    before do
      do_register
    end


    let(:user) { User.find_by_username('john') }
   

    scenario 'should be able to confirm registration' do
      john.should_not be_confirmed
      visit user_confirmation_path(:confirmation_token => john.confirmation_token) 
      john.should be_confirmed
      page.should have_content(t('devise.confirmations.confirmed')) 
    end


    scenario 'should not confrim registration more than once' do
      url = user_confirmation_path(:confirmation_token => john.confirmation_token) 
      visit url
      visit url
      page.should have_no_content(t('devise.confirmations.confirmed'))
    end

  end

end
