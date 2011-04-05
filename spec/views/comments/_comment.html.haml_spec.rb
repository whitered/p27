require 'spec_helper'

describe 'comments/_comment.html.haml' do

  before do
    stub_template 'users/_user' => '<div class=".user" />'
    stub_template 'comments/_form' => '<div class="reply_form" />'
    p = Post.make!(:author => User.make!)
    @current_comment = Comment.build_from(p, User.make!.id, Faker::Lorem.sentence)
    @current_comment.save!
    @locals = { :comment => @current_comment, :reply => false }
  end

  def do_render
    render :partial => 'comments/comment', :locals => @locals
  end

  let(:page) { Capybara.string rendered }

  it 'should have class .comment' do
    do_render
    page.should have_selector('.comment')
  end

  it 'should have id like "comment_{id}"' do
    do_render
    page.should have_selector("#comment_#{@current_comment.id}")
  end

  it 'should have comment body' do
    do_render
    page.should have_content(@current_comment.body)
  end

  it 'should render user partial for comment owner' do
    do_render
    page.should render_template('users/_user')
  end

  it 'should have comment creation date' do
    do_render
    page.should have_content(l(@current_comment.created_at))
  end

  it 'should have reply link if @comment is assigned' do
    @comment = Comment.build_from(@current_comment.commentable, User.make!.id, Faker::Lorem.sentence)
    do_render
    page.should have_link(t('comments.comment.reply'), :href => post_path(@current_comment.commentable, :comment_id => @current_comment.id))
  end

  it 'should have link to parent comment' do
    @locals[:parent_id] = '12345'
    do_render
    page.find('#comment_' + @current_comment.id.to_s).should have_link(t('comments.comment.parent'), :href => '#comment_12345')
  end

  it 'should not have link to parent if no parent exists' do
    do_render
    page.should have_no_link(t('comments.comment.parent'))
  end

  it 'should have class .indent_0 by default' do
    do_render
    page.should have_selector('.indent_0')
  end

  it 'should have indent class depending on local variable :indent' do
    @locals[:indent] = 8
    do_render
    page.should have_selector('.indent_8')
  end

  it 'should render child comments with increased indent' do
    child = Comment.build_from(@current_comment.commentable, User.make!.id, Faker::Lorem.sentence)
    child.parent = @current_comment
    child.save!
    @locals[:indent] = 3
    do_render
    page.should have_selector('.indent_3#comment_' + @current_comment.id.to_s)
    page.should have_selector('.indent_4#comment_' + child.id.to_s)
    page.find('.indent_3').should have_content(@current_comment.body)
    page.find('.indent_4').should have_content(child.body)
  end

  it 'should render reply form if current_comment is a parent of the new one' do
    @post = @current_comment.commentable
    @comment = Comment.build_from(@post, User.make!.id, Faker::Lorem.sentence)
    @comment.parent = @current_comment
    do_render
    page.should render_template('comments/_form')
  end

  it 'should not render reply form if current comment is not a parent of the new one' do
    @post = @current_comment.commentable
    parent = Comment.build_from(@post, User.make!.id, Faker::Lorem.sentence)
    parent.save!
    @comment = Comment.build_from(@post, User.make!.id, Faker::Lorem.sentence)
    @comment.parent = parent
    do_render
    page.should_not render_template('comment/_form')
  end
end
