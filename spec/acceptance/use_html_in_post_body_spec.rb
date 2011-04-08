require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Use HTML In Post Body' do

  background do
    @group = Group.make!
    @user = User.make!
    @user.groups << @group
  end

  scenario 'create post with html tags' do
    login @user
    visit new_group_post_path(@group)
    fill_in t('activerecord.attributes.post.body'), :with => '<a href="http://example.org/article"><b>bold text</b></a><img src="http://example.com/image.jpg"><i>italic text</i>'
    click_button t('posts.new.commit')

    page.should have_link('bold text', :href => 'http://example.org/article')
    page.should have_xpath('//img[@src = "http://example.com/image.jpg"]')
    page.should have_selector('b', :text => 'bold text')
    page.should have_selector('i', :text => 'italic text')
  end

end
