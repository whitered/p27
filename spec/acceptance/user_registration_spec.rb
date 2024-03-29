require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "User Registration" do

  context 'guest' do

    def do_register
      visit new_user_registration_path
      fill_in t('activerecord.attributes.user.username'), :with => 'john_doe'
      fill_in t('activerecord.attributes.user.email'), :with => 'john_doe@mail.com'
      fill_in t('activerecord.attributes.user.password'), :with => 'qwerty'
      fill_in t('activerecord.attributes.user.password_confirmation'), :with => 'qwerty'
      click_link_or_button t('registrations.new.submit')
    end

    
    scenario 'should be able to register' do
      lambda do
        do_register
      end.should change(User, :count).by(1)
      page.should have_content(t('registrations.create.confirm_registration'))
    end
    
    
    scenario 'should not be able to register with already taken nickname' do
      User.make! :username => 'john_doe'
      lambda do
        do_register
      end.should_not change(User, :count)
      
      page.should have_content(t_error(User, :username, :taken))
    end


    scenario 'should receive confirmation email after registration' do
      do_register
      user = User.find_by_username 'john_doe'
      url = user_confirmation_url(:confirmation_token => user.confirmation_token, :host => 'localhost:3000')
      email = ActionMailer::Base.deliveries.last
      email.to.should eq(['john_doe@mail.com'])
      email.body.raw_source.should include(url)
    end

  end

  scenario 'registration with wrong link' do
    visit new_user_registration_path(:invitation => 'wrong_code')
    page.should have_content(t('registrations.new.wrong_invitation'))
  end

  context 'having an invitation' do

    background do
      @group = Group.make!
      @inviter = User.make!
      @invitation = Invitation.make!(:group => @group, :inviter => @inviter, :email => Faker::Internet.email)
    end

    scenario 'registration by link' do
      ActionMailer::Base.deliveries = []
      username = 'my_name'
      visit new_user_registration_path(:invitation => @invitation.code)
      fill_in t('activerecord.attributes.user.username'), :with => username
      fill_in t('activerecord.attributes.user.password'), :with => 'qwerty'
      fill_in t('activerecord.attributes.user.password_confirmation'), :with => 'qwerty'
      click_link_or_button t('registrations.new.submit')
      page.should have_content(t('registrations.create.registered_and_confirmed'))
      ActionMailer::Base.deliveries.should be_empty
      visit group_path(@group)
      within('#group_users') do
        page.should have_link(username)
      end
    end

    scenario 'registration with one of several invitations' do
      invitation2 = Invitation.create!(:email => @invitation.email, :inviter => User.make!, :group => Group.make!)
      visit new_user_registration_path(:invitation => @invitation.code)
      fill_in t('activerecord.attributes.user.username'), :with => 'username'
      fill_in t('activerecord.attributes.user.password'), :with => 'asdasd'
      fill_in t('activerecord.attributes.user.password_confirmation'), :with => 'asdasd'
      click_link_or_button t('registrations.new.submit')
      visit invitations_path
      page.should have_content(invitation2.group.name)
      page.should have_content(invitation2.inviter.username)
    end

  end

end
