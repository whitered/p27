require 'spec_helper'

describe 'groups/_group.html.haml' do

  before do 
    @group = Group.make!
    @group.users << User.make!(2)
    render :partial => 'groups/group.html.haml', :locals => { :group => @group }
  end

  let(:page) { Capybara.string rendered }

  it 'should have group name' do
    page.should have_content(@group.name)
  end

  it 'should have number of group members' do
    page.should have_content(@group.users.count.to_s)
  end

  it 'should have link to group page' do
    page.should have_xpath(".//a[@href='#{group_path(@group)}']")
  end

end
