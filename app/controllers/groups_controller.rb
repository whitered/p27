class GroupsController < ApplicationController

  before_filter :authenticate_user!

  def new
    @group = Group.new
  end

  def create
    params[:group][:owner_id] = current_user.id
    @group = current_user.groups.create(params[:group])
    @group.set_admin_status current_user, true
    redirect_to @group
  end

  def show
    @group = current_user.groups.find_by_id(params[:id]) || current_user.own_groups.find_by_id(params[:id])
    raise ActiveRecord::RecordNotFound if @group.nil?
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


  def add_user
    group = Group.find(params[:id])
    if !group.user_is_admin?(current_user)
      flash[:error] = t('groups.add_user.errors.not_permitted')
    elsif params[:name].nil?
      flash[:error] = t('groups.add_user.errors.no_name_given')
    else
      usernames = params[:name].split(/\W+/)
      wrong_names = []
      usernames.each do |username|
        user = User.find(:first, :conditions => [ 'lower(username) = ?', username.downcase ])
        if user.nil?
          wrong_names << username
        else
          group.users << user unless group.users.exists?(user)
        end
      end
      flash[:error] = t('groups.add_user.errors.wrong_names', :names => wrong_names.join(', ')) unless wrong_names.empty?
    end
    redirect_to group
  end

  def remove_user
    group = Group.find(params[:id])
    if !group.user_is_admin?(current_user)
      flash[:error] = t('groups.remove_user.errors.not_permitted')
    elsif params[:username].nil?
      flash[:error] = t('groups.remove_user.errors.no_name_given')
    else
      user = group.users.find(:first, :conditions => [ 'lower(username) = ?', params[:username].downcase ])
      if user.nil?
        flash[:error] = t('groups.remove_user.errors.user_not_found', :username => params[:username])
      else
        group.users.delete user
        flash[:notice] = t('groups.remove_user.successful', :username => user.username)
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

end
