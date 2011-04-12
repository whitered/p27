require 'spec_helper'

describe GamesController do

  describe 'new' do

    before do
      @group = Group.make!
      @user = User.make!
    end

    def get_new
      get :new, :group_id => @group.id
    end

    it 'should require user authentication' do
      get_new
      response.should redirect_to(new_user_session_path)
    end

    it 'should raise NotFound exception if user is not a member of the group' do
      sign_in @user
      lambda do
        get_new
      end.should raise_exception(ActiveRecord::RecordNotFound)

    end

    context 'for authorized user' do

      before do
        @group.users << @user
        sign_in @user
      end

      it 'should build new game' do
        Game.should_receive(:new)
        get_new
      end

      it 'should assing :game' do
        get_new
        assigns[:game].should be_a(Game)
      end

      it 'should render :new template' do
        get_new
        response.should render_template(:new)
      end

      it 'should be successful' do
        get_new
        response.should be_successful
      end
    end
    

  end

  describe 'create' do

    before do
      @group = Group.make!
      @params = { 
        :group_id => @group.id,
        :game => {
          :date => Date.today + 1,
          :description => 'The New Year Tourney',
          :place => 'Blogistan'
        }
      }
    end

    def do_create 
      post :create, @params
    end

    it 'should require user authentication' do
      do_create
      response.should redirect_to(new_user_session_path)
    end

    it 'should raise NotFound exception if user is not authorized to create game' do
      sign_in User.make!
      lambda do
        do_create
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    context 'for authorized user' do

      before do
        @user = User.make!
        @group.users << @user
        sign_in @user
      end

      it 'should create new game' do
        lambda do
          do_create
        end.should change(Game, :count).by(1)
      end

      it 'should redirect to new game' do
        do_create
        response.should redirect_to(Game.last)
      end

      it 'should set current user as announcer' do
        do_create
        Game.last.announcer.should eq(@user)
      end

      it 'should set group for new game' do
        do_create
        Game.last.group.should eq(@group)
      end
      
    end

  end

  describe 'show' do

    before do
      @game = Game.make!(:announcer => User.make!, :group => Group.make!)
    end

    def do_show
      get :show, :id => @game.id
    end

    it 'should raise RecordNotFound for wrong game' do
      lambda do
        get :show, :id => 0
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    context 'for game from private group' do

      before do
        @game.group.update_attribute(:private, true)
      end

      it 'should raise RecordNotFound for outsider' do
        sign_in User.make!
        lambda do
          do_show
        end.should raise_exception(ActiveRecord::RecordNotFound)
      end

      it 'should raise RecordNotFound for not logged in user' do
        lambda do
          do_show
        end.should raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    context 'for authorized user' do
      it 'should assign :game' do
        do_show
        assigns[:game].should eq(@game)
      end

      it 'should be successful' do
        do_show
        response.should be_successful
      end

      it 'should render :show template' do
        do_show
        response.should render_template(:show)
      end
    end

  end
end
