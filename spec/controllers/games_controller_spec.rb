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

  describe 'index' do

    context 'top level' do

      it 'should assign @games' do
        get :index
        assigns[:games].should_not be_nil
      end

      describe '@games' do

        before do 
          public_groups = Group.make!(2, :private => false)
          private_group = Group.make!(:private => true)
          announcer = User.make!
          games = (1..5).map do |day|
            Game.make(:announcer => User.make!, :date => Date.today + day)
          end
          public_groups[0].games << games[0]
          public_groups[1].games << games[1..2]
          private_group.games << games[3..4]
          games[2..3].each { |game| game.update_attribute(:archived, true) }
          @public_games = games[0..2]
          @private_games = games[3..4]
          @archived_games = games[2..3]
        end

        let(:games) { assigns[:games] }

        it 'should contain all public unarchived games' do
          get :index
          (@public_games - @archived_games).each do |game|
            games.should include(game)
          end
        end

        it 'should not contain any of the private games' do
          get :index
          @private_games.each do |game|
            games.should_not include(game)
          end
        end

        it 'should not contain any of the archived games' do
          get :index
          @archived_games.each do |game|
            games.should_not include(game)
          end
        end

        it 'should have games ordered by date' do
          get :index
          games.should == @public_games[0..1]
        end

      end

      it 'should render :index template' do
        get :index
        response.should render_template(:index)
      end

      it 'should be successful' do
        get :index
        response.should be_successful
      end

    end

    context 'inside a group' do

      before do
        @group = Group.make!
        announcer = User.make!
        @games = (1..3).map do |n|
          Game.make!(:announcer => announcer, :group => @group, :date => DateTime.now + n)
        end
        @games[1].update_attribute(:archived, true)
      end

      def get_index
        get :index, :group_id => @group.id
      end

      it 'should raise NotFound for not authenticated user' do
        @group.update_attribute(:private, true)
        lambda do
          get_index
        end.should raise_exception(ActiveRecord::RecordNotFound)
      end

      context 'for authorized user' do

        it 'should assign @games' do
          get_index
          assigns[:games].should_not be_nil
        end

        it 'should assign @group' do
          get_index
          assigns[:group].should == @group
        end

        it 'should not find games that belong to another group' do
          game = Game.make!(:announcer => User.make!, :group => Group.make!)
          get_index
          assigns[:games].should_not include(game)
        end

        it 'should not include archive games' do
          get_index
          assigns[:games].should == [@games[0], @games[2]]
        end

        it 'should render :index template' do
          get_index
          response.should render_template(:index)
        end

        it 'should be successful' do
          get_index
          response.should be_successful
        end
      end
    end
  end

  describe 'join' do

    before do
      @group = Group.make!
      @user = User.make!
      @game = Game.make!(:announcer => User.make!, :group => @group)
    end

    def do_join 
      post :join, :id => @game.id
    end

    it 'should require user authentication' do
      do_join
      response.should redirect_to(new_user_session_path)
    end

    it 'should raise RecordNotFound if user is not a member of the group' do
      sign_in @user
      lambda do
        do_join
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    it 'should raise MethodNotAllowed if user has already joined the game' do
      @group.users << @user
      @game.players << @user
      sign_in @user
      lambda do
        do_join
      end.should raise_exception(ActionController::MethodNotAllowed)
    end

    context 'when method is allowed' do

      before do
        @group.users << @user
        sign_in @user
      end

      it 'should create new participation' do
        lambda do
          do_join
        end.should change(Participation, :count).by(1)
        p = Participation.last
        p.user.should eq(@user)
        p.game.should eq(@game)
      end

      it 'should redirect to game page' do
        do_join
        response.should redirect_to(@game)
      end

    end
  end

  describe 'leave' do

    before do
      @group = Group.make!
      @user = User.make!
      @game = Game.make!(:announcer => User.make!, :group => @group)
    end

    def do_leave
      post :leave, :id => @game.id
    end
    
    it 'should require user authentication' do
      do_leave
      response.should redirect_to(new_user_session_path)
    end

    it 'should raise RecordNotFound if user is not a member of the group' do
      sign_in @user
      lambda do
        do_leave
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    it 'should raise MethodNotAllowed if user is not a participant of the game' do
      @group.users << @user
      sign_in @user
      lambda do
        do_leave
      end.should raise_exception(ActionController::MethodNotAllowed)
    end

    context 'when method is allowed' do

      before do
        @group.users << @user
        @game.players << @user
        sign_in @user
      end

      it 'should destroy participation' do
        lambda do
          do_leave
        end.should change(Participation, :count).by(-1)
        Participation.find_by_user_id_and_game_id(@user.id, @game.id).should be_nil
      end

      it 'should redirect to game page' do
        do_leave
        response.should redirect_to(game_path(@game))
      end
    end
  end

  describe 'edit' do

    before do
      @user = User.make!
      @group = Group.make!
      @game = Game.make!(:announcer => @user, :group => @group)
    end

    def do_edit
      get :edit, :id => @game.id
    end

    it 'should require user authentication' do
      do_edit
      response.should redirect_to(new_user_session_path)
    end

    it 'should raise NotFound if user is not authenticated to edit game' do
      sign_in User.make!
      lambda do
        do_edit
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    context 'for authenticated user' do

      before do
        @group.users << @user
        sign_in @user
      end

      it 'should assign @game' do
        do_edit
        assigns[:game].should eq(@game)
      end

      it 'should render :edit template' do
        do_edit
        response.should render_template(:edit)
      end

      it 'should be successful' do
        do_edit
        response.should be_successful
      end
    end
  end

  describe 'update' do

    before do
      @group = Group.make!
      @user = User.make!
      @game = Game.make!(:announcer => @user, :group => @group)
      @game_params = {
        :date => 3.days.from_now,
        :description => 'Completely new description',
        :rebuy => 1,
        :buyin => 4,
        :addon => 7
      }
    end

    def do_update
      put :update, :id => @game.id, :game => @game_params
    end

    it 'should require user authentication' do
      do_update
      response.should redirect_to(new_user_session_path)
    end

    it 'should raise NotFound if user is not authorized for editing' do
      sign_in User.make!
      lambda do
        do_update
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    context 'for authorized user' do

      before do
        @group.users << @user
        sign_in @user
      end

      it 'should update game' do
        do_update
        @game.reload
        @game.date.should eq(@game_params[:date])
        @game.description.should eq(@game_params[:description])
        @game.rebuy.should eq(@game_params[:rebuy])
        @game.buyin.should eq(@game_params[:buyin])
        @game.addon.should eq(@game_params[:addon])
      end

      it 'should assign @game' do
        do_update
        assigns[:game].should eq(@game)
      end

      it 'should redirect to game' do
        do_update
        response.should redirect_to(game_path(@game))
      end

    end
  end

  describe 'archive' do

    before do 
      @group = Group.make!
      @group.games << Game.make(2, :announcer => User.make!, :archived => true)
      @group.games << Game.make(:announcer => User.make!)
    end

    def get_archive
      get :archive, :group_id => @group.id
    end

    it 'should raise NotFound exception if user cannot view requested group' do
      @group.update_attribute(:private, true)
      lambda do
        get_archive
      end.should raise_exception(ActiveRecord::RecordNotFound)
    end

    context 'for authorized user' do

      it 'should assign archived groups to @groups' do
        get_archive
        assigns[:games].should == @group.games[0..1]
      end

      it 'should render :index' do
        get_archive
        response.should render_template(:index)
      end

      it 'should be successful' do
        get_archive
        response.should be_successful
      end

    end
  end
end
