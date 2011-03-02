require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "User Registration" do

  context 'as a guest' do

    scenario 'should be able to register' do
      lambda do
        visit new_user_registration_path
        fill_in t('activerecord.attributes.user.username'), :with => 'john_doe'
        fill_in t('activerecord.attributes.user.email'), :with => 'john_doe@mail.com'
        fill_in t('activerecord.attributes.user.password'), :with => 'qwerty'
        fill_in t('activerecord.attributes.user.password_confirmation'), :with => 'qwerty'
        click_link_or_button t('session.signup.submit')
      end.should change(User, :count).by(1)
      page.should have_content(t('devise.registrations.signed_up'))
    end
    
    
    
    scenario 'should not be able to register with already taken nickname' do
      User.make! :username => 'john_doe'
      lambda do
        visit new_user_registration_path
        fill_in t('activerecord.attributes.user.username'), :with => 'john_doe'
        fill_in t('activerecord.attributes.user.email'), :with => 'john_doe@mail.com'
        fill_in t('activerecord.attributes.user.password'), :with => 'qwerty'
        fill_in t('activerecord.attributes.user.password_confirmation'), :with => 'qwerty'
        click_link_or_button t('session.signup.submit')
      end.should_not change(User, :count)
      
      page.should have_content(t_error(User, :username, :taken))
    end

  end

end
