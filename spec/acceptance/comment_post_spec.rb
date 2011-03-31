require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Comment Post" do

  context 'group member' do

    before do
      @post = Post.make!(:group => Group.make!, :author => User.make!)
      @user = User.make!
      @post.group.users << @user
      login @user
    end

    scenario 'comments post' do
      visit post_path(@post)
      fill_in t('activerecord.attributes.comment.body'), :with => 'Here is my comment'
      click_button t('comments.form.commit')
      current_path.should eq(post_path(@post))
      page.should have_content('Here is my comment')
    end
  end

end
