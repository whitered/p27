class GroupsController < ApplicationController

  before_filter :authenticate_user!

  def new
    @group = Group.new
  end

  def create
    @group = current_user.groups.create(params[:group])
    @group.set_admin_status current_user, true
    redirect_to @group
  end

  def show
    @group = current_user.groups.find(params[:id])
  end

end
