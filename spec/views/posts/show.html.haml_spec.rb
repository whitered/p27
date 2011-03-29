require 'spec_helper'

describe "posts/show.html.haml" do

  before do
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
    page.should have_link(@post.author.username, :href => user_path(@post.author))
  end

  it 'should have group' do
    render
    page.should have_link(@post.group.name, :href => group_path(@post.group))
  end

  it 'should have link to edit page if user is authorized for editing' do
    sign_in @post.author
    render
    page.should have_link(t('posts.edit.link'), :href => edit_post_path(@post))
  end

  it 'should not have link to edit page for not authorized user' do
    sign_in User.make!
    render
    page.should have_no_link(t('posts.edit.link'))
  end
end
