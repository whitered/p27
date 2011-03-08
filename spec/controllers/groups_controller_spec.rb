require 'spec_helper'

describe GroupsController do

  describe 'new' do

    before do
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


  describe 'create' do
    
    context 'with correct params' do

      def do_post
        post :create, :group => { :name => 'GAGA Group' }
      end

      it 'should create new group' do
        lambda {
          do_post
        }.should change(Group, :count).by(1)
      end
        
      it 'should assign :group' do
        do_post
        assigns[:group].should_not be_nil
      end

      it 'should redirect to group page' do
        do_post
        response.should redirect_to(Group.last)
      end

    end
  end

end
