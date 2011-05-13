class MembershipsController < ApplicationController

  def create
    group = Group.find(params[:group_id])
    raise ActiveRecord::RecordNotFound if group.private?
    if group.hospitable?
      group.users << current_user unless group.users.exists? current_user
    else
      flash[:alert] = t('memberships.create.not_hospitable')
    end
    redirect_to group
  end

  def destroy
    membership = Membership.find(params[:id])
    leaving = current_user == membership.user
    if membership.user_can_destroy?(current_user)
      membership.destroy
      flash[:notice] = leaving ?
        t('memberships.destroy.leave_successful', :group => membership.group_name) :
        t('memberships.destroy.user_removed_successful', :username => membership.user_username)
    else
      flash[:alert] = t('memberships.destroy.not_permitted')
    end
    redirect_to leaving ? root_path : group_path(membership.group)
  end

  def update
    membership = Membership.find(params[:id])
    raise 'Permission Denied' unless membership.group.owner == current_user
    is_admin = params[:membership] && params[:membership][:is_admin]
    membership.update_attribute(:is_admin, is_admin) unless is_admin.nil?
    redirect_to membership.group
  end

end
