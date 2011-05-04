require 'spec_helper'

describe 'posts/index.html.haml' do

  before do
    @posts = Post.make!(3, :author => User.make!)
    stub_template 'posts/_post.html.haml' => '%div[post]'
    render
  end

  let(:page) { Capybara.string rendered }

  it 'should have page title' do
    page.should have_content(t('posts.index.title'))
  end

  it 'should render posts' do
    page.should render_template('posts/_post')
    page.all('#posts .post').count.should == 3
  end

end
