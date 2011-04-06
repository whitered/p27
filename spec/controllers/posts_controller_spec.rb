require 'spec_helper'

describe PostsController do

  describe 'new' do

    before do 
      @user = User.make!
      @group = Group.make!
    end

    it 'should require user authentication' do
      get :new, :group_id => @group.id
      response.should redirect_to(new_user_session_path)
    end

    it 'should require group to be defined' do
      sign_in @user
      lambda do
        get :new
      end.should raise_exception(ActionController::RoutingError)
    end

    it 'should require user to be authorized to write in the group' do
      sign_in @user
      lambda do
        get :new, :group_id => @group.id
      end.should raise_exception(AccessDenied)
    end

    context 'for authorized user' do

      before do
        @group.users << @user
        sign_in @user
      end

      it 'should build new post' do
        Post.should_receive(:new)
        get :new, :group_id => @group.id
      end

      it 'should assign :post' do
        get :new, :group_id => @group.id
        assigns[:post].should be_a(Post)
      end
      
      it 'should render :new template' do
        get :new, :group_id => @group.id
        response.should render_template(:new)
      end

    end
  end


  describe 'create' do

    before do
      @user = User.make!
      @group = Group.make!
      @params = {
        :group_id => @group.id,
        :post => {
          :title => Faker::Lorem.sentence,
          :body => Faker::Lorem.paragraphs
        }
      }
    end

    it 'should require user authentication' do
      post :create, @params
      response.should redirect_to(new_user_session_path)
    end

    it 'should require group to be defined' do
      sign_in @user
      @params.delete :group_id
      lambda do
        post :create, @params
      end.should raise_exception(ActionController::RoutingError)
    end

    it 'should require user to be authorized to post in the group' do
      sign_in @user
      lambda do
        post :create, @params
      end.should raise_exception(AccessDenied)
    end

    context 'for authorized user' do 

      before do
        @group.users << @user
        sign_in @user
      end

      it 'should create new post' do
        lambda do
          post :create, @params
        end.should change(Post, :count).by(1)
      end
      
      it 'should set post group' do
        post :create, @params
        Post.last.group.should eq(@group)
      end

      it 'should set post author' do
        post :create, @params
        Post.last.author.should eq(@user)
      end

      it 'should redirect to post page' do
        post :create, @params
        response.should redirect_to(Post.last)
      end

    end

  end


  describe 'show' do

    before do
      @group = Group.make!
      @post = Post.make!(:author => User.make!, :group => @group)
    end

    context "private group's post" do

      before do
        @group.update_attribute(:private, true)
      end

      it 'should raise NotFound exception if user is not logged in' do
        lambda do
          get :show, :id => @post.id
        end.should raise_exception(ActiveRecord::RecordNotFound)
      end

      it 'should raise NotFound exception if user is not a member' do
        sign_in User.make!
        lambda do
          get :show, :id => @post.id
        end.should raise_exception(ActiveRecord::RecordNotFound)
      end

    end

    context 'public post' do

      it 'should be success for public group post' do
        get :show, :id => @post.id
        response.should be_successful
      end

      it 'should be success for private group post when user is a member' do
        @group.update_attribute(:private, true)
        user = User.make!
        @group.users << user
        sign_in user
        get :show, :id => @post.id
        response.should be_successful
      end

      it 'should assign :post' do
        get :show, :id => @post.id
        assigns[:post].should eq(@post)
      end

      it 'should render :show template' do
        get :show, :id => @post.id
        response.should render_template(:show)
      end

    end

    it 'should assign :comment if user can comment the post' do
      user = User.make!
      @group.users << user
      sign_in user
      get :show, :id => @post.id
      assigns[:comment].should be_a(Comment)
      comment = assigns[:comment]
      comment.should be_new_record
      comment.commentable.should eq(@post)
      comment.user.should eq(user)
      comment.parent.should be_nil
    end

    it 'should assign :comment with parent_id if concrete comment specified' do
      user = User.make!
      @group.users << user
      comment = Comment.build_from(@post, User.make!.id, Faker::Lorem.sentence)
      comment.save!
      sign_in user
      get :show, :id => @post.id, :comment_id => comment.id.to_s
      assigns[:comment].should be_a(Comment)
      assigns[:comment].parent.should eq(comment)
    end

    it 'should not assign :comment if user cannot comment the post' do
      sign_in User.make!
      get :show, :id => @post.id
      assigns[:comment].should be_nil
    end

    it 'should assing :last_visit if user is logged in and have viewed the post before' do
      user = User.make!
      visit = Visit.make!(:user => user, :visitable => @post, :updated_at => 1.day.ago)
      sign_in user
      get :show, :id => @post.id
      assigns[:last_visit].should eq(visit.updated_at)
    end

    it 'should not assign :last_visit if user not logged in' do
      get :show, :id => @post.id
      assigns[:last_visit].should be_nil
    end

    it 'should assign :last_visits to the ancient enough time if user never viewed the post before' do
      sign_in User.make!
      get :show, :id => @post.id
      assigns[:last_visit].should_not be_nil
      assigns[:last_visit].should <= @post.created_at
    end

    it 'should create new visit for logged in user after first-time view' do
      user = User.make!
      sign_in user
      lambda do
        get :show, :id => @post.id
      end.should change(Visit, :count).by(1)
      visit = Visit.last
      visit.user.should eq(user)
      visit.visitable.should eq(@post)
    end

    it 'should update visit time for logged in user after repeated views' do
      user = User.make!
      Visit.make!(:user => user, :visitable => @post, :updated_at => 1.day.ago)
      sign_in user
      lambda do
        get :show, :id => @post.id
      end.should change{ Visit.last.updated_at }
      Visit.last.updated_at.should > 3.seconds.ago
    end

  end

  describe 'edit' do

    before do
      @post = Post.make!(:author => User.make!)
    end

    it 'should require user authentication' do
      get :edit, :id => @post.id
      response.should redirect_to(new_user_session_path)
    end

    it 'should raise NotFound exception if user not authorized to edit the post' do
      sign_in User.make!
      lambda do
        get :edit, :id => @post.id
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    context 'for authorized user' do

      before do
        sign_in @post.author
        get :edit, :id => @post.id
      end

      it 'should be successful' do
        response.should be_successful
      end

      it 'should assign :post' do
        assigns[:post].should eq(@post)
      end

      it 'should render :edit template' do
        response.should render_template(:edit)
      end

    end
  end

  describe 'update' do

    before do 
      @post = Post.make!(:group => Group.make!, :author => User.make!)
    end

    it 'should require user authentication' do
      put :update, :id => @post.id, :post => { :title => 'new title' }
      response.should redirect_to(new_user_session_url)
    end

    it 'should raise NotFound exception if user is not authorized to edit post' do
      sign_in User.make!
      lambda do
        put :update, :id => @post.id, :post => { :title => 'new title' }
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    context 'for authorized user' do 

      before do
        sign_in @post.author
      end

      it 'should update post title' do
        put :update, :id => @post.id, :post => { :title => 'new title' }
        Post.find(@post.id).title.should eq('new title')
      end

      it 'should update post body' do
        put :update, :id => @post.id, :post => { :body => 'new body' }
        Post.find(@post.id).body.should eq('new body')
      end

      it 'should not modify post author' do
        put :update, :id => @post.id, :post => { :author_id => -999 }
        Post.find(@post.id).author_id.should eq(@post.author_id)
      end

      it 'should not modify post group' do
        put :update, :id => @post.id, :post => { :group_id => -666 }
        Post.find(@post.id).group_id.should eq(@post.group_id)
      end

      it 'should set successful message' do
        put :update, :id => @post.id, :post => { :title => 'new title' }
        flash[:notice].should eq(t('posts.update.successful'))
      end

      it 'should redirect to post page' do
        put :update, :id => @post.id, :post => { :title => 'new title' }
        response.should redirect_to(post_path(@post))
      end

    end
  end
end
