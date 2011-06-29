require 'spec_helper'

describe "posts/new" do

  before do 
    @group = Group.make!
    @post = Post.new
    render
  end

  def content_for name
    view.instance_variable_get(:@_content_for)[name]
  end

  let(:page) { Capybara.string rendered }

  it 'should have group name in page title' do
    content_for(:title_prefix).should include(@group.name)
  end

  it 'should have field for post title' do
    page.should have_field(t('activerecord.attributes.post.title'))
  end

  it 'should have field for post body' do
    page.should have_field(t('activerecord.attributes.post.body'))
  end

  it 'should have submit button' do
    page.should have_button(t('posts.new.submit'))
  end

end
