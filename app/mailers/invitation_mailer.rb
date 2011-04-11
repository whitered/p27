class InvitationMailer < ActionMailer::Base
  default :from => 'invitation@p27.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitations.invite_user.subject
  #
  def invite_user invitation, link
    
    @invitation = invitation
    @link = link

    mail :to => invitation.email, :subject => t('invitation_mailer.invite_user.subject')
  end
end
