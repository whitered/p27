require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "View Posts Index" do
  
  background do
    @public_group = Group.make!
    @private_group = Group.make!(:private => true)
    @public_group.posts << Post.make!(2, :author => User.make!)
    @private_group.posts << Post.make!(:author => User.make!)
  end

  scenario 'view public posts' do
    visit posts_path
    @public_group.posts.each do |post|
      page.should have_content(post.title)
    end
    @private_group.posts.each do |post|
      page.should have_no_content(post.title)
    end
  end

end
