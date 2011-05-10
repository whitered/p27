class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    raise ActiveRecord::RecordNotFound unless @post.can_be_commented_by?(current_user)

    # rails_best_practices does not like that code:
    #@comment = Comment.build_from(@post, current_user.id, params[:comment][:body])
    #@comment.parent_id = params[:comment][:parent_id]

    @comment = @post.comment_threads.build(:user => current_user, 
                                    :body => params[:comment][:body], 
                                    :parent_id => params[:comment][:parent_id])
    if @comment.save
      redirect_to @comment.commentable
    else
      flash[:alert] = t('comments.create.failure')
      render 'posts/show'
    end
  end

end
