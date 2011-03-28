class InvitationsController < ApplicationController

  before_filter :authenticate_user!
  
  def new
    @group = Group.find(params[:group_id])
    raise ActiveRecord::RecordNotFound unless @group.user_is_admin?(current_user)
  end

  def create
    @group = Group.find(params[:group_id])
    raise ActiveRecord::RecordNotFound unless @group.user_is_admin?(current_user)

    sent_invitations = 0
    wrong_emails = []
    members = []
    
    recipients = params[:recipients].blank? ? [] : params[:recipients].split(/[\s;,]+/)

    if recipients.empty?
      flash[:alert] = t('invitations.create.no_recipients')
    else
      recipients.each do |name|
        user = User.find_by_username_or_email(name)
        if user.nil?
          invitation = Invitation.new(:email => name, :group => @group, :inviter => current_user)
          if invitation.save
            InvitationMailer.invite_user(invitation, new_user_registration_url(:code => invitation.code)).deliver
            sent_invitations += 1
          else
            wrong_emails << name
          end
        elsif user.groups.exists?(@group)
          members << name
        else 
          invitation = Invitation.create(:user => user, :group => @group, :inviter => current_user)
          sent_invitations += 1
        end
      end

      if sent_invitations == recipients.size
        flash[:notice] = sent_invitations > 1 ? 
          t('invitations.create.invitations_sent') : 
          t('invitations.create.invitation_sent')
      elsif wrong_emails.size + members.size > 1
        flash[:alert] = t('invitations.create.invitations_failed', :recipients => [wrong_emails + members].join(', '))
      elsif wrong_emails.any?
        flash[:alert] = t('invitations.create.wrong_email', :recipient => wrong_emails.first)
      elsif members.any?
        flash[:alert] = t('invitations.create.user_is_member', :recipient => members.first)
      end                  
    end

    render :new
  end

  def index
    @invitations = Invitation.find(:all, :conditions => { :user_id => current_user.id })
  end

  def accept
    invitation = current_user.invitations.find(params[:id])
    invitation.accept!
    flash[:notice] = t('invitations.accept.successful', :group => invitation.group.name)
    redirect_to invitations_url
  end

  def decline
    invitation = current_user.invitations.find(params[:id])
    invitation.destroy
    flash[:notice] = t('invitations.decline.successful', :group => invitation.group.name)
    redirect_to invitations_url
  end
end
