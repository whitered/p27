require 'spec_helper'

describe 'invitations/_invitation' do

  before do 
    @invitation = Invitation.make!(:group => Group.make!, :user => User.make!, :author => User.make!)
    render
  end

  let(:page) { Capybara.string rendered }

  it 'should render group name' do
    page.should have_content(@invitation.group.name)
  end

  it 'should render author username' do
    page.should have_content(@invitation.author.username)
  end

  it 'should have link to accept invitation' do
    page.should have_link(t('invitations.invitation.accept'), :href => accept_invitation_path(@invitation))
  end

  it 'should have link to decline invitation' do
    page.should have_link(t('invitations.invitation.decline'), :href => decline_invitation_path(@invitation))
  end

end
