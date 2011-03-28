require 'spec_helper'

describe "users/show.html.haml" do

  let(:page) { Capybara.string rendered }

  before do
    @user = User.make
    render
  end

  it 'should contain username' do
    page.should have_content(@user.username)
  end

end
