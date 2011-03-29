require 'spec_helper'

describe 'posts/post' do

  before do
    @post = Post.make!(:author => User.make!, :group => Group.make!)
    render :partial => 'posts/post', :locals => { :post => @post }
  end

  let(:page) { Capybara.string rendered }

  it 'should render post title' do
    page.should have_link(@post.title, :href => post_path(@post))
  end

  it 'should render post author' do
    page.should have_link(@post.author.username, :href => user_path(@post.author))
  end

  it 'should render post creation date' do
    page.should have_content(l @post.created_at)
  end

end
