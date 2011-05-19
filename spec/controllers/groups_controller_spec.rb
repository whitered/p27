require 'spec_helper'

describe GroupsController do

  describe 'new' do

    it 'should require user authentication' do
      get :new
      response.should redirect_to(new_user_session_path)
    end

    context 'for user' do

      before do
        sign_in User.make!
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
        @user = User.make!
        sign_in @user
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
        m.user.should == @user
        m.group.should == Group.last
        m.is_admin?.should be_true
      end

      it "should set user group\'s owner" do
        do_create
        Group.last.owner.should == @user
      end

    end
  end


  describe 'show' do

    before do
      @group = Group.make!
      @user = User.make!
    end

    def do_show id
      get :show, :id => id
    end

    context 'public group' do

      before do
        @group.update_attribute(:private, false)
      end

      it 'should be successful' do
        do_show @group.id
        response.should be_successful
      end

      it 'should assign :group' do
        do_show @group.id
        assigns[:group].should == @group
      end

      it 'should assign :membership nil' do
        do_show @group.id
        assigns[:membership].should be_nil
      end

    end

    context 'private group' do

      before do
        @group.update_attribute(:private, true)
      end


      it 'should not be shown to unsigned user' do
        lambda do
          do_show @group.id
        end.should raise_exception(ActiveRecord::RecordNotFound)
      end

      context "user's group" do

        before do
          @group.users << @user
          sign_in @user
        end

        it 'should be successful' do
          do_show @group.id
          response.should be_successful
        end

        it 'should assign :group' do
          do_show @group.id
          assigns[:group].should == @group
        end

        it 'should assign :membership' do
          do_show @group.id
          assigns[:membership].should == @group.memberships.find_by_user_id!(@user.id)
        end

      end

      context "owner's group" do
        
        before do
          @group.owner = @user
          @group.save!
          sign_in @user
        end

        it 'should be successful' do
          do_show @group.id
          response.should be_successful
        end

        it 'should assign :group' do
          do_show @group.id
          assigns[:group].should == @group
        end

        it 'should assign :membership' do
          do_show @group.id
          assigns[:membership].should be_nil
        end

      end

      context "another's group" do

        before do
          sign_in @user
        end
        
        it 'should raise NotFound error' do
          lambda do
            do_show @group.id
          end.should raise_error(ActiveRecord::RecordNotFound)
        end

      end

    end

    context 'non-existent group' do

      before do
        sign_in @user
      end

      it 'should raise NotFound error' do
        lambda do
          do_show 0
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end

  describe 'index' do

    before do
      @groups = Group.make!(3)
      @groups.second.update_attribute(:private, true)
      get :index
    end

    it 'should be successful' do
      response.should be_successful
    end

    it 'should assign :groups' do
      assigns[:groups].should be_a(Array)
    end

    describe '@groups' do

      it 'should contain all public groups' do
        assigns[:groups].should include(@groups.first)
        assigns[:groups].should include(@groups.third)
      end

      it 'should not contain any private groups' do
        assigns[:groups].should_not include(@groups.second)
      end

    end

    it 'should render :index template' do
      response.should render_template(:index)
    end
  end

  describe 'edit' do 

    before do
      @group = Group.make!
      @user = User.make!
    end

    def do_edit
      get :edit, :id => @group.id
    end

    it 'should require user authentication' do
      do_edit
      response.should redirect_to(new_user_session_path)
    end

    it 'should require user to be group owner' do
      sign_in @user
      lambda do
        do_edit
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end


    context 'for group owner' do

      before do
        @group.update_attribute(:owner_id, @user.id)
        sign_in @user
      end

      it 'should assign :group' do
        do_edit
        assigns[:group].should == @group
      end

      it 'should render :edit template' do
        do_edit
        response.should render_template(:edit)
      end

    end

  end

  describe 'update' do

    before do
      @group = Group.make!(:name => 'Old name')
      @user = User.make!
    end

    def do_update options
      put :update, :id => @group.id, :group => options
    end

    it 'should require user authentication' do
      do_update :name => 'New name'
      response.should redirect_to(new_user_session_path)
    end

    it 'shoudl raise NotFound exception if group is not existent' do
      sign_in @user
      lambda do
        put :update, :id => 0, :group => { :name => 'New name' }
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    it 'should raise NotFound exception if user is not owner of the group' do
      @group.users << @user
      sign_in @user
      lambda do
        do_update :name => 'New name'
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    context 'for group owner' do

      before do
        @group.update_attribute(:owner_id, @user.id)
        sign_in @user
      end

      it 'should update group name' do
        lambda do
          do_update :name => 'New name'
        end.should change{ Group.find(@group.id).name }.from('Old name').to('New name')
      end

      it 'should update group private' do
        lambda do
          do_update :private => true
        end.should change{ Group.find(@group.id).private? }.from(false).to(true)
      end

      it 'should update group hospitable' do
        lambda do
          do_update :hospitable => false
        end.should change{ Group.find(@group.id).hospitable? }.from(true).to(false)
      end

      it 'should not update group owner' do
        new_owner = User.make!
        lambda do
          do_update :owner_id => new_owner.id
        end.should_not change{ Group.find(@group.id).owner_id }
      end

      it 'should set successful notification' do
        do_update :name => 'New name'
        flash[:notice].should == t('groups.update.success')
      end

      it 'should render :edit template' do
        do_update :name => 'New name'
        response.should render_template(:edit)
      end
    end
  end

  describe 'my_groups' do

    it 'should require user authentication' do
      get :my_groups
      response.should redirect_to(new_user_session_path)
    end

    context 'for logged in user' do

      before do
        @user = User.make!
        @user.groups << Group.make!(2)
        sign_in @user
      end

      it 'should assign @groups' do
        get :my_groups
        assigns[:groups].should == @user.groups
      end

      it 'should not assign @my_groups' do
        get :my_groups
        assigns[:my_groups].should be_nil
      end

      it 'should render :index' do
        get :my_groups
        response.should render_template(:index)
      end

      it 'should be successful' do
        get :my_groups
        response.should be_successful
      end

    end
  end
end
