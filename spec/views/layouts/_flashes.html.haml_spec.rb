require 'spec_helper'

describe 'layouts/_flashes' do
  
  let(:page) { Capybara.string rendered }
  let(:flashes) { page.find '#flashes' }
  

  it 'should render both alert and notice' do
    flash[:notice] = 'Notice message'
    flash[:alert] = 'Alert message'
    render
    page.should have_css('#flashes')
    flashes.should have_content('Alert message')
    flashes.should have_content('Notice message')
  end
  
  
  it 'should not be rendered when no flash messages are given' do
    render
    page.should have_no_css('#flashes')
  end
  
  
  it 'should render alert message' do
    flash[:alert] = 'Alert message'
    render
    page.should have_css('#flashes')
    flashes.should have_css('.alert')
    flashes.should have_no_css('.notice')
  end
  
  
  it 'should render notice message' do
    flash[:notice] = 'Notice message'
    render
    page.should have_css('#flashes')
    flashes.should have_no_css('.alert')
    flashes.should have_css('.notice')
  end
  
end


