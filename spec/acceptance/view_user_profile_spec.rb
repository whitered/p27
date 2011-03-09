require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "View User Profile" do

  scenario 'anybody should be enable to view user profile' do
    user = User.make!
    visit user_path(user)
    page.should have_content(user.username)
  end

end
