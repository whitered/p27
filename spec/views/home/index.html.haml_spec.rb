require 'spec_helper'

describe "home/index.html.haml" do

  before do
    stub_template 'posts/_post.html.haml' => '.post= post.title'
  end

  let(:page) { Capybara.string rendered }

  context 'for guest' do

    it 'should not have new_group link' do
      render
      page.should have_no_link('', :href => new_group_path)
    end

  end

  context 'for user' do

    before do
      @posts = Post.make!(3, :author => User.make!)
      sign_in User.make!
    end

    it 'should have new_group link' do
      render
      page.should have_link(t('home.index.new_group'), :href => new_group_path)
    end

    it 'should have posts title' do
      render
      page.should have_content(t('home.index.posts'))
    end

    it 'should render posts' do
      render
      page.should have_selector('#posts')
      page.should render_template('posts/_post')
      page.all('#posts .post').size.should eq(3)
      @posts.each do |p|
        page.should have_content(p.title)
      end
    end
  end

end
