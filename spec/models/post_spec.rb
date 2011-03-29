require 'spec_helper'

describe Post do

  it 'should have title' do
    Post.new.should respond_to(:title)
  end

  it 'should have body' do
    Post.new.should respond_to(:body)
  end

  it 'should have author' do
    Post.new.should respond_to(:author)
  end

  describe 'author' do
    it 'should not be nil' do
      post = Post.new
      post.should be_invalid
      post.errors[:author_id].should_not be_empty
      post.author = User.make!
      post.should be_valid
    end
  end

  it 'should have group' do
    Post.new.should respond_to(:group)
  end

end
