require 'spec_helper'

describe 'users/_user.html.haml' do

  before do
    @user = User.make!
    render :partial => 'users/user', :locals => { :user => @user }
  end

  let(:page) { Capybara.string rendered }

  it 'should render username' do
    page.should have_content(@user.username)
  end

  it 'should have link to user profile' do
    page.should have_xpath(".//a[@href = '#{user_path(@user)}']")
  end

end
