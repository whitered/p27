class RegistrationsController < Devise::RegistrationsController

  rescue_from ActiveRecord::RecordNotFound, :with => :wrong_invitation

  before_filter :find_invitation, :only => [:new, :create]

  def create
    @user = User.new(params[:user])

    if @user.valid?
      unless @invitation.nil?
        @user.skip_confirmation! if @user.email.downcase == @invitation.email.downcase
      end
    end

    if @user.save
      @invitation.accept! @user unless @invitation.nil?

      invitations = Invitation.find(:all, :conditions => [ 'lower(email) = ?', @user.email.downcase ])
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

end
