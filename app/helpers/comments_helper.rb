module CommentsHelper

  def novelty_class comment, last_visit
    (last_visit.present? && last_visit < comment.created_at) ? 'new' : ''
  end

  def new_comment_for? comment
    @comment.present? && @comment.parent == comment
  end
end
