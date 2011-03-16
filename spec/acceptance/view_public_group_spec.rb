require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'View Public Group' do

  scenario 'guest can view public group' do
    @group = Group.make!
    @member = User.make!
    @group.users << @member
    visit group_path(@group)
    page.should have_content(@group.name)
    page.should have_content(@member.username)
  end

end
