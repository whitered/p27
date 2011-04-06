class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.build_from(@post, current_user.id, params[:comment][:body])
    raise ActiveRecord::RecordNotFound unless @comment.commentable.can_be_commented_by?(@comment.user)
    @comment.parent_id = params[:comment][:parent_id]
    if @comment.save
      redirect_to @comment.commentable
    else
      flash[:alert] = t('comments.create.failure')
      render 'posts/show'
    end
  end

end
