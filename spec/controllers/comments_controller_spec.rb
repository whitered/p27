require 'spec_helper'

describe CommentsController do

  before do
    @post = Post.make!(:group => Group.make!, :author => User.make!)
    @user = User.make!
    @valid_comment = {
      :comment => {
        :body => 'This is comment body',
        :commentable_id => @post.id,
        :commentable_type => 'Post',
        :user_id => @user.id
      }
    }
  end

  describe 'create' do

    it 'should require user authentication' do
      post :create, @valid_comment
      response.should redirect_to(new_user_session_path)
    end

    it 'should require user authorization to comment the post' do
      sign_in @user
      lambda do
        post :create, @valid_comment
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    context 'for authorized user' do 

      before do
        @post.group.users << @user
        sign_in @user
      end

      it 'should create new comment' do
        lambda do
          post :create, @valid_comment
        end.should change(Comment, :count).by(1)
        comment = Comment.last
        comment.user.should eq(@user)
        comment.commentable.should eq(@post)
        comment.body.should eq('This is comment body')
      end

      it 'should redirect to post page' do
        post :create, @valid_comment
        response.should redirect_to(@post)
      end

    end

  end
end
