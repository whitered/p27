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

  def send_invitations recipients
    visit new_group_invitation_path(@group)
    fill_in t('invitations.new.recipients'), :with => recipients
    fill_in t('invitations.new.message'), :with => 'Join my group!'
    click_link_or_button t('invitations.new.submit')
  end

  scenario 'group admin visits invitations page' do
    visit group_path(@group)
    click_link t('groups.show.new_invitation')
    current_path.should eq(new_group_invitation_path(@group))
  end

  scenario 'group admin sends invitation to registered user by username' do
    send_invitations @recipient.username
    page.should have_content(t('invitations.create.invitation_sent'))
  end

  scenario 'group admin sends invitation to registered user by email' do
    send_invitations @recipient.email
    page.should have_content(t('invitations.create.invitation_sent'))
  end

  scenario 'group admin sends invitation to registered user by username' do
    send_invitations 'dude@hotmail.com'
    page.should have_content(t('invitations.create.invitation_sent'))
  end

  scenario 'group admin send invitations to several users' do
    send_invitations [@recipient.username, 'dude@hotmail.com'].join(',')
    page.should have_content(t('invitations.create.invitations_sent'))
  end

end
