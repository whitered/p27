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

  describe 'add_user' do

    let(:group) { Group.make! }

    before do
      group.users << user
    end

    it 'should require user authentication' do
      post :add_user, :id => group.id, :name => 'John'
      response.should redirect_to(new_user_session_path)
    end

    it 'should require user to be an admin' do
      sign_in user
      lambda {
        post :add_user, :id => group.id, :name => User.make!.username
      }.should_not change(group.users, :count)
      flash[:error].should eq(t('groups.add_user.errors.not_permitted'))
    end

    context 'as admin' do

      before do
        sign_in user
        group.set_admin_status user, true
      end

      def do_add_user name
        post :add_user, :id => group.id, :name => name
      end

       it 'should add multiple users to the group' do
        ivanov = User.make!(:username => 'Ivanov')
        petrov = User.make!(:username => 'Petrov')
        do_add_user 'Ivanov, Petrov'
        group.users.should include(ivanov)
        group.users.should include(petrov)
      end

      it 'should ignore case in usernames' do
        ivanov = User.make!(:username => 'Ivanov')
        petrov = User.make!(:username => 'Petrov')
        do_add_user 'ivanov, pEtRoV'
        group.users.should include(ivanov)
        group.users.should include(petrov)
      end

      it 'should ignore not existant users' do
        User.make!(:username => 'Ivanov')
        lambda {
          do_add_user 'Ivanov, Petrov'
        }.should change(group.users, :count).by(1)
      end

      it 'should redirect to the group page' do
        do_add_user User.make!.username
        response.should redirect_to(group)
      end

      it 'should show error message if no names are given' do
        do_add_user nil
        flash[:error].should eq(t('groups.add_user.errors.no_name_given'))
      end
      
      it 'should show error message for not existant users' do
        User.make!(:username => 'Petrov')
        do_add_user 'Ivanov, Petrov Sidorov'
        flash[:error].should eq(t('groups.add_user.errors.wrong_names', :names => 'Ivanov, Sidorov'))
      end

    end

  end


  describe 'remove_user' do

    let(:group) { Group.make! }
    let(:member) { User.make! }

    before do
      group.users << user << member
    end

    it 'should require user authentication' do
      post :remove_user, :id => group.id, :username => member.username
      response.should redirect_to(new_user_session_path)
    end

    it 'should require user to be admin' do
      sign_in user
      lambda {
        post :remove_user, :id => group.id, :username => member.username
      }.should_not change(group.users, :count)
      flash[:error].should eq(t('groups.remove_user.errors.not_permitted'))
    end

    context 'group admin' do

      def do_remove_user username
        post :remove_user, :id => group.id, :username => username
      end

      before do
        group.set_admin_status user, true
        sign_in user
      end

      it 'should remove specified user' do
        lambda do
          do_remove_user member.username
        end.should change(group.users, :count).by(-1)
      end

      it 'should redirect to the group page' do
        do_remove_user member.username
        response.should redirect_to(group)
      end

      it 'should have success notification' do
        do_remove_user member.username
        flash[:notice].should eq(t('groups.remove_user.successful', :username => member.username))
      end

      it 'should render error if no username given' do
        do_remove_user nil
        flash[:error].should eq(t('groups.remove_user.errors.no_name_given'))
      end

      it 'should not remove not existant user' do
        lambda do
          do_remove_user 'Somebody_else'
        end.should_not change(group.users, :count)
      end

      it 'should display error message if requested user not found' do
        do_remove_user 'somebody_else'
        flash[:error].should eq(t('groups.remove_user.errors.user_not_found', :username => 'somebody_else'))
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
end
