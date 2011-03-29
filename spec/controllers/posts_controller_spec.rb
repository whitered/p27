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

    context 'allowed post' do

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

  end

end