class HomeController < ApplicationController

  skip_before_filter :authenticate_user!, :only => :index

  def index
    if user_signed_in?
      @posts = Post.joins('INNER JOIN memberships ON memberships.group_id = posts.group_id').where(:memberships => {:user_id => current_user.id}).order('created_at DESC')
    end
  end

end
