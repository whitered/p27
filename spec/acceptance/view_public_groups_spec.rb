require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'View Public Groups' do

  scenario 'guest can view public groups' do
    @groups = Group.make!(3)
    visit groups_path
    @groups.each do |group|
      page.should have_link(group.name, :href => group_path(group))
    end
  end
end
