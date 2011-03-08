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

    end
  end

  describe 'show' do

    context 'with correct params' do

      let(:group) { Group.make! }

      def do_show
        get :show, :id => group.id
      end

      it 'should be successful' do
        do_show
        response.should be_successful
      end

      it 'should assign :group' do
        do_show
        assigns[:group].should be_a(Group)
      end

    end

    context 'with wrong params' do
      
      def do_show
        get :show, :id => '-1'
      end

      it 'should raise NotFound error' do
        lambda {
          do_show
        }.should raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end
end
