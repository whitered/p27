class GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def create
    @group = Group.create(params[:group])
    redirect_to @group
  end

  def show
  end

end
