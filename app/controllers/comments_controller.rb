class CommentsController < ApplicationController

  def create
    comment = Comment.new(params[:comment])
    raise ActiveRecord::RecordNotFound unless comment.commentable.can_be_commented_by?(comment.user)
    comment.save!
    redirect_to comment.commentable
  end

end
