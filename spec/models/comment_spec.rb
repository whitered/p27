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
end
