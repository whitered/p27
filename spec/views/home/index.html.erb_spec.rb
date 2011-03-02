require 'spec_helper'

describe "home/index.html.erb" do

  let(:page) { Capybara.string rendered }

  before(:each) do
    render
  end

  it 'should show welcome' do
    page.should have_content(t('home.index.welcome'))
  end

end
