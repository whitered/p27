require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Send Invitation" do

  background do
    @group = Group.make!
    @admin = User.make!
    @group.users << @admin
    @group.set_admin_status @admin, true
    @recipient = User.make!
    login @admin
  end

  def send_invitation recipient
    visit new_group_invitation_path(@group)
    fill_in t('activerecord.attributes.invitation.recipient'), :with => recipient
    fill_in t('activerecord.attributes.invitation.message'), :with => 'Join my group!'
    click_link_of_button t('invitations.new.commit')
  end

  scenario 'group admin sends invitation to registered user by username' do
    send_invitation @recipient.username
    page.should have_content(t('invitations.new.successful'))
  end

  scenario 'group admin sends invitation to registered user by email' do
    send_invitation @recipient.email
    page.should have_content(t('invitations.new.successful'))
  end

  scenario 'group admin sends invitation to registered user by username' do
    send_invitation 'dude@hotmail.com'
    page.should have_content(t('invitations.new.successful'))
  end

end
