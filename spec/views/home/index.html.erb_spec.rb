require 'spec_helper'

describe "home/index.html.erb" do

  let(:page) { Capybara.string rendered }

  before(:each) do
    render
  end

  it 'should show welcome' do
    page.should have_content(t('home.index.welcome'))
  end

  context 'for user' do

    before do
      sign_in User.make!
    end

    it 'should have new_group link' do
      page.should have_xpath("//a[@href='#{new_group_path}']")
    end

  end

end
