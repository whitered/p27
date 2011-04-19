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
      click_button t('comments.form.submit')
      current_path.should eq(post_path(@post))
      page.should have_content('Here is my comment')
    end

    scenario 'comments comment' do
      comment = Comment.build_from(@post, @user.id, Faker::Lorem.sentence)
      comment.save!
      visit post_path(@post)
      find("#comment_#{comment.id}").click_link_or_button(t('comments.comment.reply'))
      fill_in t('activerecord.attributes.comment.body'), :with => 'This is my reply'
      click_button t('comments.form.submit')
      current_path.should eq(post_path(@post))
      page.should have_selector('.comment.indent_1')
      page.find('.comment.indent_1').should have_content('This is my reply')
    end
  end

end
