require 'spec_helper'

describe CommentsController do

  before do
    @post = Post.make!(:group => Group.make!, :author => User.make!)
    @user = User.make!
    @params = {
      :post_id => @post.id,
      :comment => {
        :body => 'This is comment body',
      }
    }
  end

  describe 'create' do

    it 'should require user authentication' do
      post :create, @params
      response.should redirect_to(new_user_session_path)
    end

    it 'should require user authorization to comment the post' do
      sign_in @user
      lambda do
        post :create, @params
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    context 'for authorized user' do 

      before do
        @post.group.users << @user
        sign_in @user
      end

      it 'should create new comment' do
        lambda do
          post :create, @params
        end.should change(Comment, :count).by(1)
        comment = Comment.last
        comment.user.should eq(@user)
        comment.commentable.should eq(@post)
        comment.body.should eq('This is comment body')
      end

      it 'should create nested comment if parent comment_id is given and parent comment belongs ot the same post' do
        parent_comment = Comment.build_from(@post, @user.id, Faker::Lorem.sentence)
        parent_comment.save!
        @params[:comment][:parent_id] = parent_comment.id
        post :create, @params
        comment = Comment.last
        comment.parent.should eq(parent_comment)
      end

      it 'should show alert message if comment was not valid' do
        parent_comment = Comment.build_from(Post.make!(:author => User.make!), @user.id, Faker::Lorem.sentence)
        parent_comment.save!
        @params[:comment][:parent_id] = parent_comment.id
        lambda do
          post :create, @params
        end.should_not change(Comment, :count)
        flash[:alert].should_not be_blank
      end

      it 'should not lose message if comment was not saved' do
        parent_comment = Comment.build_from(Post.make!(:author => User.make!), @user.id, Faker::Lorem.sentence)
        parent_comment.save!
        @params[:comment][:parent_id] = parent_comment.id
        lambda do
          post :create, @params
        end.should_not change(Comment, :count)
        assigns[:comment][:body].should eq(@params[:comment][:body])
      end

      it 'should redirect to post page' do
        post :create, @params
        response.should redirect_to(@post)
      end

    end

  end
end
