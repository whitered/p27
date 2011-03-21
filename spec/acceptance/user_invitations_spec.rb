require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "User Invitations" do

  background do
    @user = User.make!
  end


  scenario 'user views his invitations' do
    Invitation.create(:user => @user, :author => User.make!, :group => @group1)
    Invitation.create(:user => @user, :author => User.make!, :group => @group2)

    login @user
    visit invitations_path
    page.should have_content(@group1.name)
    page.should have_content(@group2.name)
  end


end
