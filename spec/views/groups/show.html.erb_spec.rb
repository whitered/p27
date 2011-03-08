require 'spec_helper'

describe "groups/show.html.erb" do

  let(:page) { Capybara.string rendered }

  before do
    @group = Group.make
    render
  end

  it 'should render group name' do
    page.should have_content(@group.name)
  end

end
