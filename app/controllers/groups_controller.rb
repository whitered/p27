class GroupsController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:show, :index]

  before_filter :find_own_group, :only => [:edit, :update]

  def new
    @group = Group.new
  end

  def create
    @group = current_user.groups.create(params[:group])
    @group.update_attribute :owner_id, current_user.id
    @group.set_admin_status current_user, true
    redirect_to @group
  end

  def show
    @group = Group.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @group.user_can_view?(current_user)
    @membership = user_signed_in? ? current_user.memberships.find_by_group_id(@group.id) : nil
  end

  def manage_admins
    group = current_user.own_groups.find_by_id!(params[:id])
    if params[:set].blank? && params[:unset].blank?
      flash[:alert] = t('groups.manage_admins.errors.no_name_given')
    else
      wrong_names = []

      unless params[:set].blank?
        params[:set].split(/\W+/).each do |name|
          user = group.users.find(:first, :conditions => [ 'lower(username) = ?', name.downcase ])
          if user.nil?
            wrong_names << name
          else
            group.set_admin_status user, true
          end
        end
      end

      unless params[:unset].blank?
        params[:unset].split(/\W+/).each do |name|
          user = group.users.find(:first, :conditions => [ 'lower(username) = ?', name.downcase ])
          if user.nil?
            wrong_names << name
          else
            group.set_admin_status user, false
          end
        end
      end

      flash[:alert] = t('groups.manage_admins.errors.wrong_names', :names => wrong_names.join(', ')) unless wrong_names.empty?
    end

    redirect_to group
  end

  def index
    @groups = Group.find_all_by_private(false)
  end

  def edit
  end

  def update
    @group.update_attributes(params[:group])
    flash[:notice] = t('groups.update.success')
    render :edit
  end

private

  def find_own_group
    @group = current_user.own_groups.find(params[:id])
  end

end
