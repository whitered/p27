require 'spec_helper'

describe GroupsController do

  let(:user) { User.make! }

  describe 'new' do

    it 'should require user authentication' do
      get :new
      response.should redirect_to(new_user_session_path)
    end

    context 'for user' do

      before do
        sign_in user
        get :new
      end

      it 'should be successful' do
        response.should be_successful
      end

      it 'should assign :group' do
        assigns[:group].should_not be_nil
      end

      it 'should render template :new' do
        response.should render_template(:new)
      end
      
    end
  end


  describe 'create' do

    it 'should require user authentication' do
      post :create, :group => { :name => 'GAGA Group' }
      response.should redirect_to(new_user_session_path)
    end
    
    context 'for logged in user with correct params' do

      before do
        sign_in user
      end

      def do_create
        post :create, :group => { :name => 'GAGA Group' }
      end

      it 'should create new group' do
        lambda {
          do_create
        }.should change(Group, :count).by(1)
      end
        
      it 'should assign :group' do
        do_create
        assigns[:group].should_not be_nil
      end

      it 'should redirect to group page' do
        do_create
        response.should redirect_to(Group.last)
      end

      it 'should make user admin of the group' do
        do_create
        m = Membership.last
        m.user.should eq(user)
        m.group.should eq(Group.last)
        m.is_admin?.should be_true
      end

    end
  end

  describe 'show' do

    it 'should require user authentication' do
      get :show, :id => Group.make!.id
      response.should redirect_to(new_user_session_path)
    end

    context 'for logged in user' do

      before do
        sign_in user
      end

      context "show user's group" do

        let(:group) { Group.make! }

        before do
          group.users << user
          get :show, :id => group.id
        end

        it 'should be successful' do
          response.should be_successful
        end

        it 'should assign :group' do
          assigns[:group].should eq(group)
        end

      end

      context "show another's group" do
        
        def do_show
          group = Group.make!
          get :show, :id => group.id
        end

        it 'should raise NotFound error' do
          lambda {
            do_show
          }.should raise_error(ActiveRecord::RecordNotFound)
        end

      end

      context "show non-existent group" do

        def do_show
          get :show, :id => '0'
        end

        it 'should raise NotFound error' do
          lambda {
            do_show
          }.should raise_error(ActiveRecord::RecordNotFound)
        end
      end

    end

  end
end
