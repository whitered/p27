require 'spec_helper'
require 'devise/test_helpers'

describe 'devise/registrations/new.html.erb' do

  let(:user) { stub_model(User).as_new_record }

  before(:each) do
    assign(:user, user)
    @view.stub(:resource).and_return(user)
    @view.stub(:resource_name).and_return('user')
    @view.stub(:devise_mapping).and_return(Devise.mappings[:user])
  end

  let(:page) { Capybara.string rendered }

  it 'should contain page title' do
    render
    page.should have_content(t('devise.registrations.new.title'))
  end

  it 'should contain email field' do
    render
    page.should have_field(t('activerecord.attributes.user.email'))
  end

  it 'should contain username field' do
    render
    page.should have_field(t('activerecord.attributes.user.username'))
  end

  it 'should contain password field' do
    render
    page.should have_field(t('activerecord.attributes.user.password'))
  end

  it 'should contain password confirmation field' do
    render
    page.should have_field(t('activerecord.attributes.user.password_confirmation'))
  end

  it 'should contain submit button' do
    render
    page.should have_button(t('devise.registrations.new.submit'))
  end

end
