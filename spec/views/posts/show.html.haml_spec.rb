require 'spec_helper'

describe "posts/show.html.haml" do

  before do
    @post = Post.make!(:author => User.make!, :group => Group.make!)
    render
  end

  let(:page) { Capybara.string rendered }

  it 'should have post title' do
    page.should have_content(@post.title)
  end

  it 'should have post body' do
    page.should have_content(@post.body)
  end

  it 'should have post creation date' do
    page.should have_content(l @post.created_at)
  end

  it 'should have author' do
    page.should have_link(@post.author.username, :href => user_path(@post.author))
  end

  it 'should have group' do
    page.should have_link(@post.group.name, :href => group_path(@post.group))
  end
end
