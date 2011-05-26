require 'spec_helper'

describe 'shared/_date.html.haml' do

  before do
    @date = Time.now + 1.month
    render 'shared/date', :date => @date
  end

  let(:page) { Capybara.string rendered }

  it 'should have :time tag' do
    page.should have_selector('time')
  end

  it 'should have real date in title' do
    page.first(:xpath, './/time/@title').text.should == l(@date, :format => :long)
  end
end
