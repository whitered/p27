require "spec_helper"

describe InvitationMailer do

  describe 'invite_user' do

    before do
      @invitation = Invitation.make(:email => Faker::Internet.email,
                                    :group => Group.make!,
                                    :inviter => User.make!)
      @link = Faker::Internet.domain_name
    end

    let(:mail) { InvitationMailer.invite_user @invitation, @link }
    

    it 'renders the headers' do
      mail.subject.should eq(t('invitation_mailer.invite_user.subject'))
      mail.to.should eq([@invitation.email])
      mail.from.should eq(['invitation@p27.com'])
    end

    it 'renders the body' do
      mail.body.encoded.should match(t('invitation_mailer.invite_user.body',
                                       :inviter => @invitation.inviter.username,
                                       :group => @invitation.group.name,
                                       :registration_link => @link))
    end

    it 'renders the body with message' do
      @invitation.message = Faker::Lorem.sentence
      mail.body.encoded.should match(t('invitation_mailer.invite_user.body_with_message',
                                       :inviter => @invitation.inviter.username,
                                       :group => @invitation.group.name,
                                       :message => @invitation.message,
                                       :registration_link => @link))
    end


  end

end
