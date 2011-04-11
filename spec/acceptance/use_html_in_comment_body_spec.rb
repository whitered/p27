require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Use Html In Comment Body' do

  background do
    @user = User.make!
    group = Group.make!
    @user.groups << group
    @post = Post.make!(:group => group, :author => User.make!)
  end

  scenario 'user creates comment with html' do
    login @user
    visit post_path(@post)
    fill_in 'comment[body]', :with => '<a href="www.site.org">link</a><b>image:</b><img src="image.gif">'
    click_link_or_button t('comments.form.commit')
    page.should have_link('link', :href => 'www.site.org')
    page.should have_selector('b', :text => 'image:')
    page.should have_xpath('.//img[@src = "image.gif"]')
  end
end
