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

  describe 'submenu' do

    subject do
      render
      Capybara.string view.instance_variable_get(:@_content_for)[:submenu]
    end

    it { should have_link(t('home.index.groups'), :href => groups_path) }

    it { should have_link(t('home.index.posts'), :href => posts_path) }

    it { should have_link(t('home.index.games'), :href => games_path) }
  end

end
