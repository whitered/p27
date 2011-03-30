require 'spec_helper'

describe 'devise/sessions/new.html.haml' do

  let(:user) { stub_model(User).as_new_record }

  before(:each) do
    assign(:user, user)
    @view.stub(:resource).and_return(user)
    @view.stub(:resource_name).and_return('user')
    @view.stub(:devise_mapping).and_return(Devise.mappings[:user])
  end

 

  let(:page) { Capybara.string rendered }


  it 'should have page title' do
    render
    page.should have_content(t 'devise.sessions.new.title')
  end

  it 'should have field for login' do
    render
    page.should have_field(t 'activerecord.attributes.user.login')
  end

  it 'should have field for password' do
    render
    page.should have_field(t 'activerecord.attributes.user.password')
  end

  it 'should have submit button' do
    render
    page.should have_button(t 'devise.sessions.new.commit')
  end

  it 'should render error for login' do
    user.errors.add(:login)
    render
    page.should have_content(t_error(User, :login))
  end

  it 'should render errors for password' do
    user.errors.add(:password)
    render
    page.should have_content(t_error(User, :password))
  end

end
