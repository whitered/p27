class InvitationsController < ApplicationController

  before_filter :authenticate_user!
  
  def new
    @group = Group.find(params[:group_id])
    raise ActiveRecord::RecordNotFound unless @group.user_is_admin?(current_user)
  end

  def create
  end

end
