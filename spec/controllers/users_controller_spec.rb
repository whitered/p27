require 'spec_helper'

describe UsersController do

  describe 'show' do

    context 'with existant username' do

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
  end

end
