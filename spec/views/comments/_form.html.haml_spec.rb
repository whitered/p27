require 'spec_helper'

describe 'comments/_form.html.haml' do

  before do
    @post = Post.make!(:group => Group.make!, :author => User.make!)
    @comment = Comment.new
    render 
  end

  let(:page) { Capybara.string rendered }

  it 'should have id "comment_form"' do
    page.should have_selector('#comment_form')
  end

  it 'should have proper action' do
    page.find('form')[:action].should eq(post_comments_path(@post))
  end

  it 'should have field for body' do
    page.should have_field(t('activerecord.attributes.comment.body'))
  end

  it 'should have commit button' do
    page.should have_button(t('comments.form.commit'))
  end
end
