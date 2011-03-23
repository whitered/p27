class RegistrationsController < Devise::RegistrationsController

  rescue_from ActiveRecord::RecordNotFound, :with => :wrong_invitation

  before_filter :find_invitation, :only => [:new, :create]

  def new
    super
  end

  def create
    @user = User.new(params[:user])

    if @user.save

      unless @invitation.nil?
        @invitation.accept
        @user.skip_confirmation if @user.email.downcase == @invitation.email.downcase
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

end
