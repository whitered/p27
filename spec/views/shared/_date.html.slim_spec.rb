require 'spec_helper'

describe 'shared/_date' do

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

  it 'should have time_in_words content' do
    page.should have_content(time_in_words(@date))
  end
end
