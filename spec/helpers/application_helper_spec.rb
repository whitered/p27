# encoding: utf-8
require 'spec_helper'

describe ApplicationHelper do

  before do
    I18n.locale = :ru
  end

  describe 'time_in_words' do
    [
      [1.day + 10.minutes, 'через 1 день'],
      [1.year + 3.months + 6.minutes, 'через 1 год и 3 месяца']
    ].each do |time, output|
      it "should render #{output}" do
        time_in_words(Time.now + time).should == output
      end
    end

  end
end
