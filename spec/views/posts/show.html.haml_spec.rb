require 'spec_helper'

describe "posts/show.html.haml" do

  before do
    stub_template 'comments/_form' => '<div id="comment_form" />'
    stub_template 'comments/_comment' => '<div class="comment"/>'
    stub_template 'users/_user' => '<div class="user"><%= user.username %></div>'
    @post = Post.make!(:author => User.make!, :group => Group.make!)
  end

  let(:page) { Capybara.string rendered }

  it 'should have post title' do
    render
    page.should have_content(@post.title)
  end

  it 'should have post body' do
    render
    page.should have_content(@post.body)
  end

  it 'should have post creation date' do
    render
    page.should have_content(l @post.created_at)
  end

  it 'should have author' do
    render
    page.find('.user').should have_content(@post.author.username)
  end

  it 'should have group' do
    render
    page.should have_link(@post.group.name, :href => group_path(@post.group))
  end

  it 'should have link to edit page if user is authorized for editing' do
    sign_in @post.author
    render
    page.should have_link(t('posts.show.edit'), :href => edit_post_path(@post))
  end

  it 'should not have link to edit page for not authorized user' do
    sign_in User.make!
    render
    page.should have_no_link(t('posts.edit.link'))
  end

  it' should not render comments form if @comment is not assigned' do
    render
    page.should_not render_template('comments/_form')
  end

  it 'should render comments for if @comment is assigned' do
    @comment = Comment.new
    render
    page.should render_template('comments/_form')
  end

  it 'should render comments' do
    render
    page.should have_selector('#post_comments')
  end

  it 'should render comment template for each comment' do
    3.times { @post.comments.create!(:user => User.make!, :body => Faker::Lorem.sentence) }
    render
    page.all('.comment').size.should eq(3)
  end
end
