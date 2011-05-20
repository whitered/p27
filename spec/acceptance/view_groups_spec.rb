require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "View Groups" do

  scenario 'guest can view public group' do
    @group = Group.make!
    @member = User.make!
    @group.users << @member
    visit group_path(@group)
    page.should have_content(@group.name)
    page.should have_content(@member.username)
  end

  scenario 'guest can view public groups' do
    groups = Group.make!(3)
    visit groups_path
    groups.each do |group|
      page.should have_link(group.name, :href => group_path(group))
    end
  end

  context 'signed in user' do

    background do
      @user = User.make!
      @user.groups << Group.make!(3)
      login @user
    end

    scenario 'can view my groups' do
      visit root_path
      click_link_or_button t('layouts.sidebar.my_groups')
      current_path.should == my_groups_path
      @user.groups.each do |group|
        page.should have_content(group.name)
      end
    end
  end

end
