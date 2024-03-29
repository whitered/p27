require 'spec_helper'

describe 'comments/_form' do

  before do
    @post = Post.make!(:group => Group.make!, :author => User.make!)
    @comment = Comment.new
  end

  def do_render 
    render 'comments/form', :comment => @comment, :post => @post
  end

  let(:page) { Capybara.string rendered }

  it 'should have id "comment_form"' do
    do_render 
    page.should have_selector('#comment_form')
  end

  it 'should have proper action' do
    do_render 
    page.find('form')[:action].should eq(post_comments_path(@post))
  end

  it 'should have field for body' do
    do_render 
    page.should have_field(t('activerecord.attributes.comment.body'))
  end

  it 'should have submit button' do
    do_render 
    page.should have_button(t('comments.form.submit'))
  end

  it 'should have hidden field for parent_id if it was specified' do
    @comment.parent_id = '543'
    do_render
    page.should have_xpath('.//form//input[@type = "hidden" and @value = "543"]')
  end

  it 'should do_render comment errors' do
    @comment.errors.add(:commentable, 'Vai-vai-vai, error!')
    do_render 
    page.should have_content('Vai-vai-vai, error!')
  end
end
