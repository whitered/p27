class InvitationsController < ApplicationController

  before_filter :authenticate_user!
  
  def new
    @group = Group.find(params[:group_id])
    raise ActiveRecord::RecordNotFound unless @group.user_is_admin?(current_user)
  end

  def create
    @group = Group.find(params[:group_id])
    raise ActiveRecord::RecordNotFound unless @group.user_is_admin?(current_user)

    sent_invitations = []
    wrong_invitations = []
    params[:recipients].split(/[\s;,]+/).each do |name|
      user = User.find_by_username_or_email(name)
      if user.nil?
        invitation = Invitation.new(:email => name)
      else 
        invitation = Invitation.new(:user => user)
      end
      invitation.group = @group
      invitation.author = current_user
      if invitation.save
        InvitationMailer.invite_user(invitation, new_user_registration_url(:code => invitation.code)).deliver
        sent_invitations << name
      else
        wrong_invitations << name
      end
    end

    if wrong_invitations.empty?
      flash[:notice] = (sent_invitations.size > 1) ? t('invitations.create.invitations_sent') : t('invitations.create.invitation_sent')
    else
      if wrong_invitations.size > 1
        i18key = 'invitations.create.wrong_emails'
        i18params = {:recipients => wrong_invitations.join(', ')}
      else
        i18key = 'invitations.create.wrong_email'
        i18params = {:recipient => wrong_invitations.first}
      end
      flash[:error] = t(i18key, i18params)
    end


    render :new
  end

  def index
    @invitations = Invitation.find(:all, :conditions => { :user_id => current_user.id })
  end

  def accept
    invitation = current_user.invitations.find(params[:id])
    Membership.create(:user => current_user, :group => invitation.group, :inviter => invitation.author)
    invitation.destroy
    flash[:notice] = t('invitations.accept.successful', :group => invitation.group.name)
    redirect_to invitations_path
  end
end
