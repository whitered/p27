require 'spec_helper'

describe MembershipsController do

  describe 'create' do

    before do
      @group = Group.make!
      @user = User.make!
    end

    def do_create
      post :create, :group_id => @group.id
    end

    it 'should require user authentication' do
      do_create
      response.should redirect_to(new_user_session_path)
    end

    context 'with valid params' do
      
      before do
        sign_in @user
      end

      it 'should raise RecordNotFound if group is private' do
        @group.update_attribute(:private, true)
        lambda do
          do_create
        end.should raise_exception(ActiveRecord::RecordNotFound)
      end

      context 'for hospitable group' do

        before do
          @group.update_attribute(:hospitable, true)
        end

        it 'should create new membership' do
          lambda do
            do_create
          end.should change(Membership, :count).by(1)
          m = Membership.last
          m.user.should == @user
          m.group.should == @group
        end
      end

      context 'for not hospitable group' do 

        before do
          @group.update_attribute(:hospitable, false)
        end

        it 'should not create any memberships' do
          lambda do
            do_create
          end.should_not change(Membership, :count)
        end

        it 'should set flash alert' do
          do_create
          flash[:alert].should == t('memberships.create.not_hospitable')
        end

      end

      it 'should redirect to group page' do
        do_create
        response.should redirect_to(group_path(@group))
      end

    end

  end


  describe 'destroy' do

    before do
      @user = User.make!
      @group = Group.make!
      @membership = Membership.make!(:user => @user, :group => @group)
    end

    def do_destroy
      delete :destroy, :id => @membership.id
    end

    it 'should require user authentication' do
      do_destroy
      response.should redirect_to(new_user_session_path)
    end

    it 'should destroy membership if user is authorized for it' do
      admin = User.make!
      @group.users << admin
      @group.set_admin_status admin, true
      sign_in admin
      lambda do
        do_destroy
      end.should change(Membership, :count).by(-1)
      Membership.find_by_group_id_and_user_id(@group.id, @user.id).should be_nil
    end

    it 'should not destroy membership if user is not authorized for it' do
      member = User.make!
      @group.users << member
      sign_in member
      lambda do
        do_destroy
      end.should_not change(Membership, :count)
      flash[:alert].should == t('memberships.destroy.not_permitted')
    end

    it 'should destroy own membership' do
      sign_in @user
      lambda do
        do_destroy
      end.should change(Membership, :count).by(-1)
      Membership.find_by_id(@membership.id).should be_nil
    end

    it 'should redirect to root path when user removed himself' do
      sign_in @user
      do_destroy
      response.should redirect_to(root_path)
    end

    it 'should redirect to group page when admin removed somebody' do
      admin = User.make!
      @group.users << admin
      @group.set_admin_status admin, true
      sign_in admin
      do_destroy
      response.should redirect_to(group_path(@group))
    end

  end
           
end
