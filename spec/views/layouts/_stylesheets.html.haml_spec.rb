require 'spec_helper'

describe 'layouts/_stylesheets' do

  before do
    render
  end

  let(:page) { Capybara.string rendered }

  it 'should include formtastic css' do
    page.should have_xpath('//link[contains(@href, "formtastic")]')
  end
end
