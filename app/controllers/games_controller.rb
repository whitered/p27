class GamesController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:show, :index, :archive]

  before_filter :find_game, :only => [:show, :edit, :update]
  before_filter :find_group, :only => [:new, :create]
  before_filter :find_and_check_game, :only => [:join, :leave]
  before_filter :ensure_game_is_editable, :only => [:edit, :update]

  def new
    @game = Game.new(:date => Date.tomorrow)
  end

  def create
    @game = Game.new(params[:game])
    @game.group = @group
    @game.announcer = current_user
    if @game.save
      redirect_to @game
    else
      render :new
    end
  end

  def show
    raise ActiveRecord::RecordNotFound unless @game.group.user_can_view?(current_user)
  end

  def index
    if params[:group_id].nil?
      @games = Game.current.joins(:group).where(:groups => { :private => false }).order('date')
    else
      @group = Group.find(params[:group_id])
      raise ActiveRecord::RecordNotFound unless @group.user_can_view?(current_user)
      @games = @group.games.current.order('date')
    end
  end

  def archive
    group = Group.find(params[:group_id])
    raise ActiveRecord::RecordNotFound unless group.user_can_view?(current_user)
    @games = group.games.archive.order('date DESC')
    render :index
  end

  def join
    raise ActionController::MethodNotAllowed if @game.players.include?(current_user)
    @game.participations.create!(:user => current_user)
    redirect_to @game
  end

  def leave
    raise ActionController::MethodNotAllowed unless @game.players.include?(current_user)
    @game.players.delete(current_user)
    redirect_to @game
  end

  def edit
  end

  def update
    @game.update_attributes(params[:game])
    redirect_to @game
  end

private

  def find_game
    @game = Game.find(params[:id])
  end

  def find_group
    @group = current_user.groups.find(params[:group_id])
  end

  def find_and_check_game
    @game = Game.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @game.group.users.include?(current_user)
  end

  def ensure_game_is_editable
    raise ActiveRecord::RecordNotFound unless @game.can_be_edited_by?(current_user)
  end

end
