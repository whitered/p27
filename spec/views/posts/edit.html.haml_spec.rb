require 'spec_helper'

describe 'posts/edit.html.haml' do

  before do
    @post = Post.make!(:author => User.make!)
    render
  end

  let(:page) { Capybara.string rendered }

  it 'should have page title' do
    page.should have_content(t('posts.edit.title'))
  end

  it 'should have title field' do
    page.should have_field(t('activerecord.attributes.post.title'), :value => 'nonono')
  end

  it 'should have body field' do
    page.should have_field(t('activerecord.attributes.post.body'), :text => 'body')
  end

  it 'should have submit button' do
    page.should have_button(t('posts.edit.submit'))
  end
end
