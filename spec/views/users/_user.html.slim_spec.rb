require 'spec_helper'

describe 'users/_user' do

  before do
    @user = User.make!(:name => 'Philip')
    render :partial => 'users/user', :locals => { :user => @user }
  end

  let(:page) { Capybara.string rendered }

  it 'should render username' do
    page.should have_content(@user.username)
  end

  it 'should have link to user profile' do
    page.should have_xpath(".//a[@href = '#{user_path(@user)}']")
  end

  it 'should have name in title' do
    page.should have_xpath(".//a[@title = '#{@user.name}']")
  end

end
