require 'spec_helper'

describe 'posts/index' do

  before do
    @posts = Post.make!(3, :author => User.make!)
    stub_template 'posts/_post.html.slim' => 'div class="post"'
    render
  end

  let(:page) { Capybara.string rendered }

  it 'should render posts' do
    page.should render_template('posts/_post')
    page.all('#posts .post').count.should == 3
  end

end
