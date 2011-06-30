require 'spec_helper'

describe 'devise/mailer/confirmation_instructions' do

  include Devise::Controllers::UrlHelpers

  let(:user) { User.make! }
  let(:page) { Capybara.string rendered }


  before do
    @resource = user
    render
  end


  it 'should contain username' do
    page.should have_content(@resource.username)
  end


  it 'should contain confirmation link' do
    url = confirmation_url(user, :confirmation_token => user.confirmation_token)
    page.should have_content(url)
  end
  
end
