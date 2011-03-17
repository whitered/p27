class GroupsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index]

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
    raise ActiveRecord::RecordNotFound unless @group.public? || (user_signed_in? && current_user.is_insider_of?(@group))
  end

  def manage_members
    group = current_user.own_groups.find_by_id(params[:id])
    if group.nil?
      group = current_user.groups.find(params[:id])
      unless group.user_is_admin?(current_user)
        flash[:error] = t('groups.manage_members.errors.not_permitted')
        redirect_to group
        return
      end
    end

    if params[:add].blank? && params[:remove].blank? 
      flash[:error] = t('groups.manage_members.errors.no_name_given')
    else
      if !params[:add].blank?
        wrong_names = []
        names = params[:add].split(/\W+/)
        names.each do |name|
          user = User.find(:first, :conditions => [ 'lower(username) = ?', name.downcase ])
          if user.nil?
            wrong_names << name
          elsif !group.users.exists?(user)
            group.users << user
          end
        end
        flash[:error] = t('groups.manage_members.errors.users_not_found', :names => wrong_names.join(', ')) unless wrong_names.empty?
      end

      if !params[:remove].blank?
        wrong_names = []
        removed_names = []
        params[:remove].split(/\W+/).each do |name|
          user = group.users.find(:first, :conditions => [ 'lower(username) = ?', name.downcase ])
          if user.nil?
            wrong_names << name
          else 
            group.users.delete(user)
            removed_names << user.username
          end
        end
        flash[:error] = t('groups.manage_members.errors.users_not_members', :names => wrong_names.join(', ')) unless wrong_names.empty?
        flash[:notice] = t('groups.manage_members.remove.successful', :names => removed_names.join(', ')) unless removed_names.empty?
      end
    end

    redirect_to group
  end

  def manage_admins
    group = current_user.groups.find_by_id(params[:id]) || current_user.own_groups.find_by_id(params[:id])
    raise ActiveRecord::RecordNotFound if group.nil?
    if group.owner != current_user
      flash[:error] = t('groups.manage_admins.errors.not_permitted')
    elsif params[:set].blank? && params[:unset].blank?
      flash[:error] = t('groups.manage_admins.errors.no_name_given')
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

      flash[:error] = t('groups.manage_admins.errors.wrong_names', :names => wrong_names.join(', ')) unless wrong_names.empty?
    end

    redirect_to group
  end

  def join
    group = Group.find(params[:id])
    raise ActiveRecord::RecordNotFound if group.private?
    if group.hospitable?
      group.users << current_user unless group.users.exists? current_user
    else
      flash[:error] = t('groups.join.errors.not_hospitable')
    end
    redirect_to group
  end

  def leave
    group = current_user.groups.find(params[:id])
    group.users.delete current_user
    flash[:notice] = t('groups.leave.successful', :group => group.name)
    redirect_to (group.public? ? group : root_path)
  end

  def index
    @groups = Group.find(:all, :conditions => { :private => false })
  end

  def edit
    @group = current_user.own_groups.find(params[:id])
  end

  def update
    @group = current_user.own_groups.find(params[:id])
    @group.update_attributes(params[:group])
    flash[:notice] = t('groups.edit.successful')
    render :edit
  end

end
