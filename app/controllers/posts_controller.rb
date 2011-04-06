class PostsController < ApplicationController

  before_filter :find_group, :only => [:new, :create]
  skip_before_filter :authenticate_user!, :only => :show

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
    @post = Post.find(params[:id])
    if @post.group.private?
      raise ActiveRecord::RecordNotFound unless user_signed_in? && current_user.is_insider_of?(@post.group)
    end
    if user_signed_in?
      if @post.can_be_commented_by?(current_user)
        @comment = Comment.build_from(@post, current_user.id, '')
        @comment.parent_id = params[:comment_id]
      end

      visit = @post.visits.find(:first, :conditions => { :user_id => current_user.id })
      if visit.nil?
        @post.visits.create(:user => current_user)
        @last_visit = @post.created_at
      else
        @last_visit = visit.updated_at
        visit.touch
      end
    end
  end

  def edit
    @post = Post.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @post.can_be_edited_by?(current_user)
  end

  def update
    @post = Post.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @post.can_be_edited_by?(current_user)
    @post.update_attributes(params[:post])
    flash[:notice] = t('posts.update.successful')
    redirect_to @post
  end

private

  def find_group
    @group = Group.find(params[:group_id])
  end

end
