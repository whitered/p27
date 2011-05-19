require 'spec_helper'

describe "posts/new.html.haml" do

  before do 
    @group = Group.make!
    @post = Post.new
    render
  end

  let(:page) { Capybara.string rendered }

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
