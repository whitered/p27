class PostsController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:show, :index]

  before_filter :find_group, :only => [:new, :create]
  before_filter :find_post, :only => [:show, :edit, :update]
  before_filter :ensure_post_editable, :only => [:edit, :update]

  def new
    @post = Post.new
  end

  def create
    post = @group.posts.build(params[:post])
    post.author = current_user
    post.save!
    redirect_to post
  end

  def show
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
        @post.visits.create(:user => current_user, :existing_comments => @post.comment_threads.size)
        @last_visit = @post.created_at
      else
        @last_visit = visit.updated_at
        visit.update_attribute(:existing_comments, @post.comment_threads.size)
      end
    end
  end

  def edit
  end

  def update
    @post.update_attributes(params[:post])
    flash[:notice] = t('posts.update.successful')
    redirect_to @post
  end

  def index
    @posts = Post.joins(:group).where(:groups => { :private => false }).order('created_at DESC')
  end

private

  def find_group
    @group = Group.find(params[:group_id])
    raise AccessDenied unless @group.user_can_post?(current_user)
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def ensure_post_editable
    raise ActiveRecord::RecordNotFound unless @post.can_be_edited_by?(current_user)
  end

end
