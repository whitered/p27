class RegistrationsController < Devise::RegistrationsController

  rescue_from ActiveRecord::RecordNotFound, :with => :wrong_invitation

  before_filter :find_invitation, :only => [:new, :create]

  def create # ignore_rbp
    @user = User.new(params[:user])

    @user.skip_confirmation! if Rails.env.development?

    unless @invitation.nil?
      @user.email = @invitation.email
      @user.skip_confirmation!
    end

    if @user.save
      @invitation.accept! @user unless @invitation.nil?

      invitations = Invitation.find_by_email_downcase(@user.email)
      invitations.each do |invitation|
        invitation.user = @user
        invitation.email = nil
        invitation.save
      end

      if @user.confirmed?
        flash[:notice] = t('registrations.create.registered_and_confirmed')
      else
        flash[:notice] = t('registrations.create.confirm_registration')
      end

      sign_in_and_redirect('user', @user)
    else
      render :new
    end
  end

private

  def find_invitation
    unless params[:invitation].nil?
      @invitation = Invitation.find_by_code(params.delete(:invitation))
      raise ActiveRecord::RecordNotFound if @invitation.nil?
    end
  end

  def wrong_invitation
    flash[:alert] = t('registrations.new.wrong_invitation')
    @user = User.new(params[:user])
    render :new
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

end
