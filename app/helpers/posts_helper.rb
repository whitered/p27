module PostsHelper

  def new_comments_count post, user
    count = post.new_comments_count_for user
    count.zero? ? '' : t('.new_comment', :count => count)
  end
end
