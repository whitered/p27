require 'spec_helper'

describe 'invitations/new.html.haml' do

  before do
    @group = Group.make!
    render
  end

  let(:page) { Capybara.string rendered }

  it 'should have form for invitation' do
    page.should have_selector('form', :action => group_invitations_path(@group))
  end

  it 'should have recipients field' do
    page.should have_field(t('invitations.new.recipients'))
  end

  it 'should have message field' do
    page.should have_field(t('invitations.new.message'))
  end

  it 'should have submit button' do
    page.should have_button(t('invitations.new.submit'))
  end

  it 'should have hint text' do
    page.should have_content(t('invitations.new.hint'))
  end

end
