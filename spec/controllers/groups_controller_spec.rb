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
        m.user.should eq(@user)
        m.group.should eq(Group.last)
        m.is_admin?.should be_true
      end

      it "should set user group\'s owner" do
        do_create
        Group.last.owner.should eq(@user)
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
        assigns[:group].should eq(@group)
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
          assigns[:group].should eq(@group)
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
          assigns[:group].should eq(@group)
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


  describe 'manage_members' do

    before do
      @group = Group.make!
      @member, @admin, @outsider = User.make!(3)
      @group.users << @member << @admin
      @group.set_admin_status @admin, true
    end

    def do_manage_members options={}
      options[:id] = @group.id
      post :manage_members, options
    end

    it 'should require user authentication' do
      do_manage_members :add => @outsider.username
      response.should redirect_to(new_user_session_path)
    end

    it 'should not admit outsiders' do
      sign_in @outsider
      lambda do
        do_manage_members :remove => @member.username
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end
      
    it 'should not admit regular members' do
      sign_in @member
      lambda do
        do_manage_members :add => @outsider.username
      end.should_not change{ @group.users.exists? @outsider }
      flash[:error].should eq(t('groups.manage_members.errors.not_permitted'))
      response.should redirect_to(@group)
    end

    it 'should admit group owner' do
      owner = User.make!
      owner.own_groups << @group
      sign_in owner
      lambda do
        do_manage_members :add => @outsider.username
      end.should change{ @group.users.exists? @outsider }.from(false).to(true)
      flash[:error].should be_nil
      response.should redirect_to(@group)
    end

    describe 'group admin' do
      
      before do
        sign_in @admin
      end

      it 'should be able to add new user to the group' do
        lambda do
          do_manage_members :add => @outsider.username
        end.should change{ @group.users.exists? @outsider }.from(false).to(true)
      end

      it 'should be able to add several users to the group' do
        lambda do
          do_manage_members :add => [@outsider.username, User.make!.username].join(' ')
        end.should change{ @group.users.count }.by(2)
      end

      it 'should be able to remove some users from the group' do
        lambda do
          do_manage_members :remove => @member.username
        end.should change{ @group.users.exists? @member }.from(true).to(false)
      end

      it 'should be able to add and remove users from the group same time' do
        do_manage_members :add => @outsider.username, :remove => @member.username
        @group.users.exists?(@outsider).should be_true
        @group.users.exists?(@member).should be_false
      end

      it 'should ignore case in usernames' do
        do_manage_members :add => @outsider.username.swapcase, :remove => @member.username.swapcase
        @group.users.exists?(@outsider).should be_true
        @group.users.exists?(@member).should be_false
      end

      it 'should ignore not existant users requested to be added' do
        lambda do
          do_manage_members :add => 'Who_is_it'
        end.should_not change{ @group.users.count }
      end

      it 'should not add users iteratively' do
        lambda do
          do_manage_members :add => @member.username
        end.should_not change{ @group.users.count }
      end

      it 'should ignore not member users requested to be removed' do
        lambda do
          do_manage_members :remove => 'mr_nobody'
        end.should_not change{ @group.users.count }
      end

      it 'should redirect to group page' do
        do_manage_members :remove => @admin.username
        response.should redirect_to(@group)
      end

      it 'should show notice when a member is removed' do
        do_manage_members :remove => @admin.username
        flash[:notice].should eq(t('groups.manage_members.remove.successful', :names => @admin.username))
      end
      
      it 'should set error message if no names given' do
        do_manage_members
        flash[:error].should eq(t('groups.manage_members.errors.no_name_given'))
      end

      it 'should set error message if wrong names were given to be added' do
        do_manage_members :add => 'somebody_not_existant'
        flash[:error].should eq(t('groups.manage_members.errors.users_not_found', :names => 'somebody_not_existant'))
      end

      it 'should set error message if wrong names were requested to be removed' do
        do_manage_members :remove => 'mr_wrong'
        flash[:error].should eq(t('groups.manage_members.errors.users_not_members', :names => 'mr_wrong'))
      end
    end
  end


  describe 'manage_admins' do

    def do_manage_admins options
      post :manage_admins, :id => @group.id, :set => options[:set], :unset => options[:unset]
    end

    before do
      @group = Group.make!
      @member, @admin, @owner = User.make!(3)
      @group.users << @member << @admin
      @group.owner = @owner
      @group.save!
      @group.set_admin_status @admin, true
    end

    it 'should require user authentication' do
      do_manage_admins :set => @member.username
      response.should redirect_to(new_user_session_path)
    end

    it 'should require user to be group owner' do
      sign_in @admin
      do_manage_admins :set => @member.username
      response.should redirect_to(@group)
      flash[:error].should eq(t('groups.manage_admins.errors.not_permitted'))
    end

    it 'should raise NotFound exception for outsider' do
      sign_in User.make!
      lambda do
        do_manage_admins :set => @member.username
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end
      

    context 'for group owner' do

      before do
        sign_in @owner
      end

      it 'should turn regular user to admin' do
        lambda do
          do_manage_admins :set => @member.username
        end.should change{ @group.user_is_admin? @member }.from(false).to(true)
      end

      it 'should turn admin to regular user' do
        lambda do
          do_manage_admins :unset => @admin.username
        end.should change{ @group.user_is_admin? @admin }.from(true).to(false)
      end

      it 'should show error message if some users are not group members' do
        outsider = User.make!
        do_manage_admins :set => [@member.username, outsider.username].join(' ')
        flash[:error].should eq(t('groups.manage_admins.errors.wrong_names', :names => outsider.username))
      end

      it 'should change member status ignoring outsiders' do
        outsider = User.make!
        lambda do
          do_manage_admins :unset => [@admin.username, outsider.username].join(',')
        end.should change{ @group.user_is_admin? @admin }.from(true).to(false)
      end

      it 'should redirect to group page' do
        do_manage_admins :set => @member.username
        response.should redirect_to(@group)
      end

      it 'should show error message if no names were given' do
        do_manage_admins :set => nil
        flash[:error].should eq(t('groups.manage_admins.errors.no_name_given'))
      end

      it 'should show error message if empty names were given' do
        do_manage_admins :unset => ''
        flash[:error].should eq(t('groups.manage_admins.errors.no_name_given'))
      end

      it 'should not change member status if it equals requested one' do
        lambda do
          do_manage_admins :unset => @member.username
        end.should_not change{ @group.user_is_admin? @member }
      end

      it 'should not change admin status if it equals requested one' do
        lambda do
          do_manage_admins :set => @admin.username
        end.should_not change{ @group.user_is_admin? @admin }
      end

      it 'should be able to make different actions at same time' do
        do_manage_admins :set => @member.username, :unset => @admin.username
        @group.user_is_admin?(@member).should be_true
        @group.user_is_admin?(@admin).should be_false
      end

    end

  end


  describe 'leave' do

    before do
      @user = User.make!
      @group = Group.make!
    end

    def do_leave
      post :leave, :id => @group.id
    end

    it 'should require user to be authenticated' do
      do_leave
      response.should redirect_to(new_user_session_path)
    end

    it 'should require user to be a member of the group' do
      sign_in @user
      lambda do
        do_leave
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end
      
    
    context 'for group member' do

      before do
        @group.users << @user
        sign_in @user
      end

      it 'should remove user from group' do
        lambda do
          do_leave
        end.should change{ @group.users.exists? @user }.from(true).to(false)
      end

      it 'should set flash notification' do
        do_leave
        flash[:notice].should eq(t('groups.leave.successful', :group => @group.name))
      end
      
      context 'of private group' do

        before do
          @group.update_attribute(:private, true)
        end

        it 'should redirect to root' do
          do_leave
          response.should redirect_to(root_path)
        end

      end

      context 'of public group' do

        before do
          @group.update_attribute(:private, false)
        end

        it 'should redirect to group page' do
          do_leave
          response.should redirect_to(@group)
        end

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

  describe 'join' do

    before do 
      @group = Group.make!
      @user = User.make!
    end

    def do_join
      post :join, :id => @group.id
    end

    it 'should require user authentication' do
      do_join
      response.should redirect_to(new_user_session_path)
    end
      
    it 'should raise NotFound error for not existant group' do
      sign_in @user
      lambda do
        post :join, :id => 0
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    it 'should raise NotFound error for private group' do
      @group.update_attribute(:private, true)
      sign_in @user
      lambda do
        do_join
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    it 'should show error message if group is not hospitable' do
      @group.update_attributes({ :private => false, :hospitable => false })
      sign_in @user
      do_join
      response.should redirect_to(group_path(@group))
      flash[:error].should eq(t('groups.join.errors.not_hospitable'))
    end


    context 'for hospitable public group' do

      before do
        @group.update_attributes :private => false, :hospitable => true
        sign_in @user
      end

      it 'should do nothing if user is a member of the group already' do
        @group.users << @user
        lambda do
          do_join
        end.should_not change{ @group.users.count }
      end

      it 'should add user to the group if it is not a member' do
        lambda do
          do_join
        end.should change{ @group.users.count }.by(1)
        @group.users.should include(@user)
      end

      it 'should redirect to group page' do
        do_join
        response.should redirect_to(group_path(@group))
      end
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
        assigns[:group].should eq(@group)
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

    it 'shoudl raise NotFound exception if group is not existant' do
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
        flash[:notice].should eq(t('groups.edit.successful'))
      end

      it 'should render :edit template' do
        do_update :name => 'New name'
        response.should render_template(:edit)
      end
    end
  end
end
