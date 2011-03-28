class PostsController < ApplicationController

  before_filter :find_group, :only => [:new, :create]

  def new
    raise AccessDenied unless @group.user_can_post?(current_user)
    @post = Post.new
  end

  def create
    raise AccessDenied unless @group.user_can_post?(current_user)
    post = @group.posts.build(params[:post])
    post.author = current_user
    post.save!
    redirect_to post
  end

  def show
  end

private

  def find_group
    @group = Group.find(params[:group_id])
  end

end
