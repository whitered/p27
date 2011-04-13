class GamesController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:show, :index]

  def new
    @group = current_user.groups.find(params[:group_id])
    @game = Game.new(:date => Date.tomorrow)
  end

  def create
    @group = current_user.groups.find(params[:group_id])
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
    @game = Game.find(params[:id])
    unless @game.group.public? || (user_signed_in? && @game.group.users.include?(current_user))
      raise ActiveRecord::RecordNotFound
    end
  end

  def index
    group = Group.find(params[:group_id])
    raise ActiveRecord::RecordNotFound unless group.public? || (user_signed_in? && group.users.inlude?(current_user))
    @games = group.games.order('date DESC')
  end

end
