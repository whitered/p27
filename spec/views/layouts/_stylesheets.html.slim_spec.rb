require 'spec_helper'

describe 'layouts/_stylesheets' do

  before do
    render
  end

  let(:page) { Capybara.string rendered }

end
