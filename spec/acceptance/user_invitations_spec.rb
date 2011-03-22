require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "User Invitations" do

  background do
    @user = User.make!
    @groups = Group.make!(2)
    @invitations = @groups.map { |group| Invitation.create(:user => @user, :inviter => User.make!, :group => group) }
    login @user
  end


  scenario 'user views his invitations' do
    visit invitations_path
    page.should have_content(@groups.first.name)
    page.should have_content(@groups.second.name)
  end


  scenario 'user can accept an invitation' do
    visit invitations_path
    within(:xpath, "//*[@class = 'invitation' and contains(., '#{@groups.first.name}')]") do
      click_link_or_button t('invitations.invitation.accept')
    end
    page.should have_content(t('invitations.accept.successful', :group => @groups.first.name))
    visit group_path(@groups.first)
    within '#group_users' do
      page.should have_content(@user.username)
    end
  end

end
