require 'spec_helper'

describe 'devise/passwords/new' do

  let(:page) { Capybara.string rendered }
  let(:user) { stub_model(User).as_new_record }

  before(:each) do
    assign(:user, user)
    @view.stub(:resource).and_return(user)
    @view.stub(:resource_name).and_return('user')
    @view.stub(:devise_mapping).and_return(Devise.mappings[:user])
    render
  end

  it 'should have login field' do
    page.should have_field(t('activerecord.attributes.user.login'))
  end

  it 'should have submit button' do
    page.should have_button(t('devise.passwords.new.submit'))
  end

end
