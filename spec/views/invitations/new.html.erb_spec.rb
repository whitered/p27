require 'spec_helper'

describe "invitations/new.html.erb", :focus => true do

  before do
    @invitation = Invitation.new(:group => Group.make!)
    render
  end

  let(:page) { Capybara.string rendered }

  it 'should have page title' do
    page.should have_content(t('invitations.new.title', :group => @invitation.group.name))
  end

  it 'should have form for invitation' do
    page.should have_selector('form', :action => new_group_invitation_path(@invitation.group))
  end

  it 'should have recipient field' do
    page.should have_field(t('activerecord.attributes.invitation.recipient'))
  end

  it 'should have message field' do
    page.should have_field(t('activerecord.attributes.invitation.message'))
  end

  it 'should have commit button' do
    page.should have_button(t('invitations.new.commit'))
  end

  it 'should have hint text' do
    page.should have_content(t('invitations.new.hint'))
  end

  it 'should have group name' do
    page.should have_content(@invitation.group.name)
  end

end
