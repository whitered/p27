class UsersController < ApplicationController

  skip_before_filter :authenticate_user!, :only => :show

  def show
    @user = User.find_by_username_downcase(params[:id])
    raise ActiveRecord::RecordNotFound if @user.nil?
  end

end
