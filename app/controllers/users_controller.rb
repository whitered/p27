class UsersController < ApplicationController
  def show
    @user = User.find_by_username(params[:id].downcase)
    raise ActiveRecord::RecordNotFound if @user.nil?
  end

end
