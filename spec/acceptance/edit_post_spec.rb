require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Edit Post" do

  before do
    @group = Group.make!
    @author = User.make!
    @post = Post.make!(:group => @group, :author => @author)
  end

  scenario 'post author edits post' do
    login @author
    visit post_path(@post)
    click_link_or_button(t('posts.show.edit'))
    fill_in t('activerecord.attributes.post.title'), :with => 'New title'
    fill_in t('activerecord.attributes.post.body'), :with => 'New post body'
    click_button t('posts.edit.commit')
    current_path.should eq(post_path(@post))
    page.should have_content(t('posts.update.successful'))
    page.should have_content('New title')
    page.should have_content('New post body')
  end

  scenario 'group admin edits post' do
    admin = User.make!
    @group.users << admin
    @group.set_admin_status admin, true
    login admin
    visit edit_post_path(@post)
    fill_in t('activerecord.attributes.post.title'), :with => 'New title'
    fill_in t('activerecord.attributes.post.body'), :with => 'New post body'
    click_button t('posts.edit.commit')
    current_path.should eq(post_path(@post))
    page.should have_content(t('posts.update.successful'))
    page.should have_content('New title')
    page.should have_content('New post body')
  end

end
