require 'spec_helper'

describe 'layouts/_notifications' do
  
  let(:page) { Capybara.string rendered }
  let(:notifications) { page.find '#notifications' }
  

  it 'should render both alert and notice' do
    flash[:notice] = 'Notice message'
    flash[:alert] = 'Alert message'
    render
    page.should have_css('#notifications')
    notifications.should have_content('Alert message')
    notifications.should have_content('Notice message')
  end
  
  
  it 'should not be rendered when no flash messages are given' do
    render
    page.should_not have_css('#notifications')
  end
  
  
  it 'should render alert message' do
    flash[:alert] = 'Alert message'
    render
    page.should have_css('#notifications')
    notifications.should have_css('.alert')
    notifications.should_not have_css('.notice')
  end
  
  
  it 'should render notice message' do
    flash[:notice] = 'Notice message'
    render
    page.should have_css('#notifications')
    notifications.should_not have_css('.alert')
    notifications.should have_css('.notice')
  end
  
end


