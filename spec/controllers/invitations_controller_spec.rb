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



end
