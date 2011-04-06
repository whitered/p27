require 'spec_helper'

describe 'comments/_form.html.haml' do

  before do
    @post = Post.make!(:group => Group.make!, :author => User.make!)
    @comment = Comment.new
  end

  let(:page) { Capybara.string rendered }

  it 'should have id "comment_form"' do
    render 
    page.should have_selector('#comment_form')
  end

  it 'should have proper action' do
    render 
    page.find('form')[:action].should eq(post_comments_path(@post))
  end

  it 'should have field for body' do
    render 
    page.should have_field(t('activerecord.attributes.comment.body'))
  end

  it 'should have commit button' do
    render 
    page.should have_button(t('comments.form.commit'))
  end

  it 'should have hidden field for parent_id if it was specified' do
    @comment.parent_id = '543'
    render
    page.should have_xpath('.//form//input[@type = "hidden" and @value = "543"]')
  end

  it 'should render comment errors' do
    @comment.errors.add(:commentable, 'Vai-vai-vai, error!')
    render 
    page.should have_content('Vai-vai-vai, error!')
  end
end
