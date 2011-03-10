class UsersController < ApplicationController
  def show
    @user = User.find(:first, :conditions => [ 'lower(username) = ?', params[:id].downcase ])
    raise ActiveRecord::RecordNotFound if @user.nil?
  end

end
