require 'spec_helper'

describe Comment do

  it 'should have parent' do
    Comment.new.should respond_to(:parent)
  end

  it 'should have commentable' do 
    Comment.new.should respond_to(:commentable)
  end

  describe 'commentable' do
    it 'should match parent commentable' do
      post = Post.make!(:author => User.make!)
      parent = Comment.build_from(post, User.make!.id, Faker::Lorem.sentence)
      comment = Comment.build_from(Post.make!(:author => User.make!), User.make!.id, Faker::Lorem.sentence)
      comment.parent = parent
      comment.should be_invalid
      comment.errors[:commentable].should_not be_blank
      comment.commentable = post
      comment.should be_valid
    end
  end

  describe 'body' do

    before do
      user = User.make!
      post = Post.make!(:author => user)
      @comment = Comment.build_from(post, user.id, nil)
    end

    let(:comment_body) { Capybara.string @comment.body }

    it 'should substitute <br> in place of newlines' do
      @comment.body = "first line\nsecond line"
      @comment.save!
      @comment.reload.body.should eq('first line<br>second line')
    end

    it 'should allow img tags' do
      @comment.body = '<img src="some/image.jpg">'
      @comment.save!
      @comment.reload.body.should eq('<img src="some/image.jpg">')
    end

    it 'should allow links' do
      @comment.body = '<a href="some/url">link</a>'
      @comment.save!
      comment_body.should have_link('link', :href => 'some/url')
    end

    it 'should allow i tag' do
      @comment.body = '<i>italic</i>'
      @comment.save!
      comment_body.should have_selector('i', :text => 'italic')
    end

    it 'should allow b tag' do
      @comment.body = '<b>bold</b>'
      @comment.save!
      comment_body.should have_selector('b', :text => 'bold')
    end

    it 'should close unclosed tags' do
      @comment.body = '<b>bold'
      @comment.save!
      @comment.reload.body.should eq('<b>bold</b>')
    end

    it 'should not allow script tag' do
      @comment.body = '<script>script</script>'
      @comment.save!
      comment_body.should have_no_selector('script')
    end

    it 'should not allow div tag' do
      @comment.body = '<div>content</div>'
      @comment.save!
      comment_body.should have_no_selector('div')
    end
  end

end
