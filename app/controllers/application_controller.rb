class AccessDenied < StandardError; end

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :find_my_groups

private

  def find_my_groups
    @my_groups = current_user.groups if user_signed_in?
  end
end
