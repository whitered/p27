class GroupsController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:show, :index]

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

  def remove_member
    group = current_user.own_groups.find_by_id(params[:id])
    if group.nil?
      group = current_user.groups.find(params[:id])
      unless group.user_is_admin?(current_user)
        flash[:alert] = t('groups.remove_member.errors.not_permitted')
        redirect_to group
        return
      end
    end

    if params[:username].blank? 
      flash[:alert] = t('groups.remove_member.errors.name_not_given')
    else
      user = group.users.find(:first, :conditions => [ 'lower(username) = ?', params[:username].downcase ])
      if user.nil?
        flash[:alert] = t('groups.remove_member.errors.user_not_member', :username => params[:username])
      else 
        group.users.delete(user)
        flash[:notice] = t('groups.remove_member.success', :username => params[:username])
      end
    end

    redirect_to group
  end

  def manage_admins
    group = current_user.groups.find_by_id(params[:id]) || current_user.own_groups.find_by_id(params[:id])
    raise ActiveRecord::RecordNotFound if group.nil?
    if group.owner != current_user
      flash[:alert] = t('groups.manage_admins.errors.not_permitted')
    elsif params[:set].blank? && params[:unset].blank?
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

  def join
    group = Group.find(params[:id])
    raise ActiveRecord::RecordNotFound if group.private?
    if group.hospitable?
      group.users << current_user unless group.users.exists? current_user
    else
      flash[:alert] = t('groups.join.errors.not_hospitable')
    end
    redirect_to group
  end

  def leave
    group = current_user.groups.find(params[:id])
    group.users.delete current_user
    flash[:notice] = t('groups.leave.success', :group => group.name)
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
    flash[:notice] = t('groups.update.success')
    render :edit
  end

end
