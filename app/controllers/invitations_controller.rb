class InvitationsController < ApplicationController

  before_filter :authenticate_user!
  
  def new
    membership = Membership.find(:first, :conditions => { :group_id => params[:group_id], :user_id => current_user.id })
    raise ActiveRecord::RecordNotFound unless membership && membership.is_admin?
  end

  def create
  end

end
