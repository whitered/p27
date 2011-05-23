require 'spec_helper'

describe 'registrations/edit.html.haml' do

  let(:user) { stub_model(User).as_new_record }

  before(:each) do
    assign(:user, user)
    @view.stub(:resource).and_return(user)
    @view.stub(:resource_name).and_return('user')
    @view.stub(:devise_mapping).and_return(Devise.mappings[:user])
    @view.stub(:devise_error_messages!)
  end

  let(:page) { Capybara.string rendered }

  it 'should have name field' do
    render
    page.should have_field(t('activerecord.attributes.user.name'))
  end

  it 'should have email field' do
    render
    page.should have_field(t('activerecord.attributes.user.email'))
  end

  it 'should have password field' do
    render
    page.should have_field(t('activerecord.attributes.user.password'))
  end

  it 'should have password confirmation field' do
    render
    page.should have_field(t('activerecord.attributes.user.password_confirmation'))
  end

  it 'should have current_password field' do
    render
    page.should have_field(t('activerecord.attributes.user.current_password'))
  end

  it 'should have submit button' do
    render
    page.should have_button(t('registrations.edit.submit'))
  end
end
