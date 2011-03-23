class RegistrationsController < Devise::RegistrationsController

  before_filter :find_invitation, :only => [:create]

  def create
    super
  end

private

  def find_invitation
    unless params[:invitation].nil?
      @invitation = Invitation.find_by_code(params.delete(:invitation))
      raise ActiveRecord::RecordNotFound if @invitation.nil?
    end
  end

end
