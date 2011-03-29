require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "View Group Posts" do

  before do
    @group = Group.make!
    3.times { Post.make!(:group => @group, :author => User.make!) }
  end

  scenario "user views public group's posts" do
    visit group_path(@group)
    @group.posts.each do |post|
      page.should have_link(post.title, :href => post_path(post))
      page.should have_link(post.author.username, :href => user_path(post.author))
      page.should have_content(l post.created_at)
    end

  end

end
