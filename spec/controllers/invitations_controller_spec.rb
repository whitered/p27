require 'spec_helper'

describe InvitationsController do

  describe 'new' do

    before do
      @group = Group.make!
      @admin = User.make!
      @group.users << @admin
    end

    it 'should require user authentication' do
      get :new, :group_id => @group.id
      response.should redirect_to(new_user_session_path)
    end

    it 'should raise NotFound exception if group does not exist' do
      sign_in @admin
      lambda do
        get :new, :group_id => 0
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    it 'should raise NotFound exception if user is not admin of the group' do
      sign_in @admin
      lambda do
        get :new, :group_id => @group.id
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    context 'by group admin' do

      before do
        @group.set_admin_status @admin, true
        sign_in @admin
      end

      it 'should assign :group' do
        get :new, :group_id => @group.id
        assigns[:group].should eq(@group)
      end

      it 'should render :new template' do
        get :new, :group_id => @group.id
        response.should render_template(:new)
      end

      it 'should be successful' do
        get :new, :group_id => @group.id
        response.should be_successful
      end

    end

  end



  describe 'create' do

    before do
      @group = Group.make!
      @admin = User.make!
      @group.users << @admin
    end

    let(:valid_email) { Faker::Internet.email }
    let(:invalid_email) { 'invalid@email' }

    def do_create recipients
      post :create, :group_id => @group.id, :recipients => recipients
    end

    it 'should require user authentication' do
      do_create 'anybody'
      response.should redirect_to(new_user_session_path)
    end

    it 'should raise NotFound exception if group does not exist' do
      sign_in @admin
      lambda do
        post :create, :group_id => 0, :recipients => valid_email
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    it 'should raise NotFound exception if user is not admin of the group' do
      sign_in @admin
      lambda do
        do_create valid_email
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    context 'by group admin' do

      before do
        @user = User.make!
        @group.set_admin_status @admin, true
        sign_in @admin
      end

      context 'with username of existing user' do

        it 'should create invitation for the user' do
          lambda do
            do_create @user.username
          end.should change(Invitation, :count).by(1)
          invite = Invitation.last
          invite.user.should eq(@user)
          invite.author.should eq(@admin)
          invite.group.should eq(@group)
        end
        
        it 'should set successful notice' do
          do_create @user.username
          flash[:notice].should eq(t('invitations.create.invitation_sent'))
        end

        it 'should render :new template' do
          do_create @user.username
          response.should render_template(:new)
        end

      end

      context 'with email of existing user' do

        it 'should create invitation for the user' do
          lambda do
            do_create @user.email
          end.should change(Invitation, :count).by(1)
          invite = Invitation.last
          invite.user.should eq(@user)
          invite.author.should eq(@admin)
          invite.group.should eq(@group)
        end
        
        it 'should set successful notice' do
          do_create @user.email
          flash[:notice].should eq(t('invitations.create.invitation_sent'))
        end

        it 'should render :new template' do
          do_create @user.email
          response.should render_template(:new)
        end

      end

      context 'with email of not existent user' do

        it 'should create invitation for given email' do
          lambda do
            do_create valid_email
          end.should change(Invitation, :count).by(1)
          invite = Invitation.last
          invite.email.should eq(valid_email)
          invite.author.should eq(@admin)
          invite.group.should eq(@group)
        end

        it 'should send invitation email' do
          lambda do
            do_create valid_email
          end.should change(ActionMailer::Base.deliveries, :count).by(1)
          mail = ActionMailer::Base.deliveries.last
          mail.to.should eq([valid_email])
          mail.body.raw_source.should match(Invitation.last.code)
        end

        it 'should set successful notice' do
          do_create valid_email
          flash[:notice].should eq(t('invitations.create.invitation_sent'))
        end

        it 'should render :new template' do
          do_create valid_email
          response.should render_template(:new)
        end
      end

      context 'with unrecognized value' do
        
        it 'should not create any invitations' do
          lambda do
            do_create 'not_email'
          end.should_not change(Invitation, :count)
        end

        it 'should show error message with wrong value' do
          do_create invalid_email
          flash[:error].should eq(t('invitations.create.wrong_email', :recipient => invalid_email))
        end

        it 'should render :new template' do
          do_create invalid_email
          response.should render_template(:new)
        end
      end

      context 'with several values' do

        it 'should create invitation for each valid value' do
          lambda do
            do_create [@user.username, valid_email].join(', ')
          end.should change(Invitation, :count).by(2)
        end

        it 'should show successful notice' do
          do_create [@user.username, valid_email].join(' ')
          flash[:notice].should eq(t('invitations.create.invitations_sent'))
        end

        it 'should render :new template' do
          do_create [@user.username, valid_email].join(' ')
        end
      end

      context 'with several values having some of them invalid' do

        it 'should create invitations for valid values only' do
          lambda do
            do_create [@user.username, valid_email, invalid_email].join(',')
          end.should change(Invitation, :count).by(2)
        end

        it 'should show error message with wrong values' do
          do_create [@user.username, valid_email, invalid_email].join(' ,')
          flash[:error].should eq(t('invitations.create.wrong_email', :recipient => invalid_email))
        end

        it 'should render :new template' do
          do_create [@user.username, valid_email, invalid_email].join(',')
          response.should render_template(:new)
        end
      end

    end
  end

  describe 'index' do

    it 'should require user authentication' do
      get :index
      response.should redirect_to(new_user_session_path)
    end

    it 'should find all invitations owned by user' do
      user = User.make!
      invitations = (1..3).map { Invitation.make!(:user => user, :group => Group.make!, :author => User.make! )}
      sign_in user
      get :index
      assigns[:invitations].size.should eq(3)
      invitations.each do |invitation|
        assigns[:invitations].should include(invitation)
      end
    end

    it 'should not fetch foreign invitations' do
      user = User.make!
      invitation = Invitation.make!(:user => User.make!, :group => Group.make!, :author => User.make!)
      sign_in user
      get :index
      assigns[:invitations].should_not include(invitation)
    end

  end


  describe 'accept' do
     
    before do
      @group = Group.make!
      @user, @author = User.make!(2)
      @invitation = Invitation.make!(:user => @user, :author => @author, :group => @group)
    end

    def do_accept
      post :accept, :id => @invitation.id
    end

    it 'should require user authentication' do
      do_accept
      response.should redirect_to(new_user_session_path)
    end

    it 'should raise NotFound error for not existend invitation' do
      sign_in @user
      lambda do
        post :accept, :id => 0
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    it 'should raise NotFound error for foreign invitation' do
      sign_in @user
      invitation = Invitation.make!(:user => User.make!, :author => @author, :group => @group)
      lambda do
        post :accept, :id => invitation.id
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    context 'own invitation' do

      before do
        sign_in @user
      end

      it 'should add user to the group' do
        lambda do
          do_accept
        end.should change{ @group.users.exists?(@user) }.from(false).to(true)
      end

      it 'should create new membership' do
        lambda do
          do_accept
        end.should change(Membership, :count).by(1)
        Membership.find(:first, :conditions => { :user_id => @user.id, :group_id => @group.id }).should_not be_nil
      end

      it 'should set inviter to the membership' do 
        do_accept
        Membership.find(:first, :conditions => { :user_id => @user.id, :group_id => @group.id }).inviter.should eq(@author)
      end

      it 'should remove used invitation' do
        lambda do
          do_accept
        end.should change(Invitation, :count).by(-1)
        Invitation.find(:first, :conditions => { :user_id => @user.id, :group_id => @group.id }).should be_nil
      end

      it 'should set successful flash message' do
        do_accept
        flash[:notice].should eq(t('invitations.accept.successful', :group => @group.name))
      end

      it 'should redirect to invitations page' do
        do_accept
        response.should redirect_to(invitations_path)
      end

      it 'should do nothing if user is a member of the group already' do
        @group.users << @user
        lambda do
          do_accept
        end.should_not change(Membership, :count)
      end

    end
  end
end
