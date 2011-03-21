require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "User Invitations" do

  background do
    @user = User.make!
    @groups = Group.make!(2)
  end


  scenario 'user views his invitations' do
    Invitation.create(:user => @user, :author => User.make!, :group => @groups.first)
    Invitation.create(:user => @user, :author => User.make!, :group => @groups.second)

    login @user
    visit invitations_path
    page.should have_content(@groups.first.name)
    page.should have_content(@groups.second.name)
  end


end
