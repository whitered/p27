require 'spec_helper'

describe 'posts/post' do

  before do
    stub_template 'users/_user' => '<div class="user"><%= user.username %></div>'
    @post = Post.make!(:author => User.make!, :group => Group.make!)
    @locals = { :post => @post }
  end

  def do_render
    render :partial => 'posts/post', :locals => @locals
  end

  let(:page) { Capybara.string rendered }

  it 'should render post title' do
    do_render
    page.should have_link(@post.title, :href => post_path(@post))
  end

  it 'should render post body' do
    do_render
    page.should have_content(@post.body)
  end

  it 'should render post author' do
    do_render
    page.first('.user').text.should eq(@post.author.username)
  end

  it 'should render post creation date' do
    do_render
    page.should have_content(l @post.created_at)
  end

  it 'should render group name' do
    do_render
    page.should have_link(@post.group.name, :href => group_path(@post.group))
  end

  it 'should not render group name if group is defined' do
    @locals[:group] = @post.group
    do_render
    page.should have_no_content(@post.group.name)
  end

  context 'with comments' do

    before do
      3.downto(1) do |n|
        comment = Comment.build_from(@post, User.make!.id, n.to_s + ' hours ago')
        comment.created_at = n.hours.ago
        comment.save!
      end
      @post.reload
      user = User.make!
      visit = Visit.make!(:visitable => @post, :user => user, :updated_at => 90.minutes.ago, :existing_comments => 2)
      sign_in user
    end

    it 'should render comments count' do
      do_render
      page.should have_content(t('posts.post.comment', :count => 3))
    end

    it 'should render new comments count if there are some new comments' do
      do_render
      page.should have_content(t('posts.post.new_comment', :count => 1))
    end

    it 'should not render new comments count if there are no new comments' do
      Visit.last.touch
      do_render
      page.should_not have_content(t('posts.post.new_comment', :count => 0))
    end
  end

end
