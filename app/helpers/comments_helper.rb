module CommentsHelper

  def novelty_class comment, last_visit
    (last_visit.present? && last_visit < comment.created_at) ? 'new' : ''
  end
end
