require 'spec_helper'

describe 'posts/post' do

  before do
    stub_template 'users/_user' => '<div class="user"><%= user.username %></div>'
    @post = Post.make!(:author => User.make!, :group => Group.make!)
    render :partial => 'posts/post', :locals => { :post => @post }
  end

  let(:page) { Capybara.string rendered }

  it 'should render post title' do
    page.should have_link(@post.title, :href => post_path(@post))
  end

  it 'should render post author' do
    page.first('.user').text.should eq(@post.author.username)
  end

  it 'should render post creation date' do
    page.should have_content(l @post.created_at)
  end

end
