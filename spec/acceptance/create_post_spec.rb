require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Create Post" do

  context 'group member' do

    before do
      @user = User.make!
      @group = Group.make!
      @group.users << @user
      login @user
    end

    scenario 'creates new post' do
      visit new_group_post_path(@group)
      fill_in t('activerecord.attributes.post.title'), :with => 'Post #1'
      fill_in t('activerecord.attributes.post.body'), :with => 'Post body has some text'
      click_link_or_button t('posts.new.submit')
      current_path.should eq(post_path(Post.last))
      page.should have_content('Post #1')
      page.should have_content('Post body has some text')
      page.should have_content(@user.username)
    end

  end

end
