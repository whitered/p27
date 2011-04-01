require 'spec_helper'

describe 'comments/_comment.html.haml' do

  before do
    stub_template 'users/user' => '<div class=".user" />'
    p = Post.make!(:author => User.make!)
    @comment = Comment.build_from(p, User.make!.id, Faker::Lorem.sentence)
    @comment.save!
    render :partial => 'comments/comment', :locals => { :comment => @comment }
  end

  let(:page) { Capybara.string rendered }

  it 'should have class .comment' do
    page.should have_selector('.comment')
  end

  it 'should have comment body' do
    page.should have_content(@comment.body)
  end

  it 'should render user partial for comment owner' do
    page.should render_template('users/_user')
  end

  it 'should have comment creation date' do
    page.should have_content(l(@comment.created_at))
  end
end
