require 'spec_helper'

describe 'layouts/application' do
  
  let(:page) { Capybara.string rendered }

  before do
    stub_template 'layouts/_notifications' => ''
    stub_template 'layouts/_authentication' => ''
    render
  end

  it 'should render _notifications template' do
    page.should render_template('layouts/_notifications')
  end

  it 'should render _authentication template' do
    page.should render_template('layouts/_authentication')
  end

  describe 'stylesheets' do

    it 'should include formstatic' do
      page.should have_xpath("//head//link[contains(@href, 'formstatic')]")
    end

  end

end
