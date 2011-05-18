require 'spec_helper'

describe 'layouts/application' do
  
  let(:page) { Capybara.string rendered }

  before do
    stub_template 'layouts/header' => ''
    stub_template 'layouts/flashes' => ''
    stub_template 'layouts/footer' => ''
    stub_template 'layouts/javascripts' => ''
    stub_template 'layouts/sidebar' => ''
    render
  end

  it 'should render header partial' do
    page.should render_template('layouts/_header')
  end

  it 'should render flashes partial' do
    page.should render_template('layouts/_flashes')
  end

  it 'should render footer partial' do
    page.should render_template('layouts/_footer')
  end

  it 'should render javascripts partial' do
    page.should render_template('layouts/_javascripts')
  end

  it 'should render sidebar partial' do
    page.should render_template('layouts/_sidebar')
  end

end
