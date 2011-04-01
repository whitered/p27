require 'spec_helper'

describe 'comments/_comment.html.haml' do

  before do
    stub_template 'users/user' => '<div class=".user" />'
    p = Post.make!(:author => User.make!)
    @comment = Comment.build_from(p, User.make!.id, Faker::Lorem.sentence)
    @comment.save!
    @locals = { :comment => @comment }
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
    page.should have_selector("#comment_#{@comment.id}")
  end

  it 'should have comment body' do
    do_render
    page.should have_content(@comment.body)
  end

  it 'should render user partial for comment owner' do
    do_render
    page.should render_template('users/_user')
  end

  it 'should have comment creation date' do
    do_render
    page.should have_content(l(@comment.created_at))
  end

  it 'should have reply link if reply local is true' do
    @locals[:reply] = true
    do_render
    page.should have_link(t('comments.comment.reply'), :href => post_path(@comment.commentable, :comment_id => @comment.id))
  end
end
