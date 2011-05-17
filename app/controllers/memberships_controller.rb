class MembershipsController < ApplicationController

  before_filter :find_membership, :only => [:update, :destroy]

  def create
    group = Group.find(params[:group_id])
    raise ActiveRecord::RecordNotFound if group.private?
    if group.hospitable?
      group.add_user current_user
    else
      flash[:alert] = t('memberships.create.not_hospitable')
    end
    redirect_to group
  end

  def destroy # ignore_rbp
    leaving = current_user == @membership.user
    if @membership.user_can_destroy?(current_user)
      @membership.destroy
      flash[:notice] = leaving ?
        t('memberships.destroy.leave_successful', :group => @membership.group_name) :
        t('memberships.destroy.user_removed_successful', :username => @membership.user_username)
    else
      flash[:alert] = t('memberships.destroy.not_permitted')
    end
    redirect_to leaving ? root_path : group_path(@membership.group)
  end

  def update
    raise ActiveRecord::RecordNotFound unless @membership.group_owner == current_user # ignore_rbp
    is_admin = params[:membership] && params[:membership][:is_admin]
    @membership.update_attribute(:is_admin, is_admin) unless is_admin.nil?
    redirect_to @membership.group
  end

private

  def find_membership
    @membership = Membership.find(params[:id])
  end
end
