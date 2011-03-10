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
      flash[:error] = t('groups.add_user.errors.wrong_names', :names => wrong_names.join(", ")) unless wrong_names.empty?
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

end
