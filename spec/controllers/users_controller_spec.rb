require 'spec_helper'

describe UsersController do

  describe 'show' do

    it 'should ignore username case' do
      @user = User.make!(:username => 'vaSYA')
      get :show, :id => 'VASya'
      response.should be_successful
      assigns[:user].should eq(@user)
    end

    context 'with existent username' do

      before do
        @user = User.make!
        get :show, :id => @user.username
      end

      it 'should be successful' do
        response.should be_successful
      end

      it 'should assign :user' do
        assigns[:user].should eq(@user)
      end

      it 'should render :show template' do
        response.should render_template(:show)
      end

    end

    context 'with not existent username' do

      it 'should raise NotFound error' do
        lambda {
          get :show, :id => 'wrong_name'
        }.should raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

end
