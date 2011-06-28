require 'spec_helper'

describe 'invitations/_invitation' do

  before do 
    @invitation = Invitation.make!(:group => Group.make!, :user => User.make!, :inviter => User.make!)
    render :partial => 'invitations/invitation', :locals => { :invitation => @invitation }
  end

  let(:page) { Capybara.string rendered }
  let(:node) { page.find('.invitation') }

  it 'should have class invitations' do
    page.should have_selector('.invitation')
  end

  it 'should render group name' do
    node.should have_content(@invitation.group.name)
  end

  it 'should render inviter username' do
    node.should have_content(@invitation.inviter.username)
  end

  it 'should have link to accept invitation' do
    node.should have_link(t('invitations.invitation.accept'), :href => accept_invitation_path(@invitation))
  end

  it 'should have link to decline invitation' do
    node.should have_link(t('invitations.invitation.decline'), :href => decline_invitation_path(@invitation))
  end

end
