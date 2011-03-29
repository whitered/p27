class UsersController < ApplicationController

  skip_before_filter :authenticate_user!, :only => :show

  def show
    @user = User.find(:first, :conditions => [ 'lower(username) = ?', params[:id].downcase ])
    raise ActiveRecord::RecordNotFound if @user.nil?
  end

end
