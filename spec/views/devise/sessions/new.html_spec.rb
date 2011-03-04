require 'spec_helper'

describe 'devise/sessions/new.html.erb' do

  let(:user) { stub_model(User).as_new_record }

  before(:each) do
    assign(:user, user)
    @view.stub(:resource).and_return(user)
    @view.stub(:resource_name).and_return('user')
    @view.stub(:devise_mapping).and_return(Devise.mappings[:user])
  end

 

  let(:page) { Capybara.string rendered }

  before do
    @resource = User.new
    render
  end

  it 'should have page title' do
    page.should have_content(t 'devise.sessions.new.title')
  end

  it 'should have field for login' do
    page.should have_field(t 'activerecord.attributes.user.login')
  end

  it 'should have field for password' do
    page.should have_field(t 'activerecord.attributes.user.password')
  end

  it 'should have submit button' do
    page.should have_button(t 'devise.sessions.new.submit')
  end

end
