require 'spec_helper'

describe 'groups/index.html.erb' do

  before do 
    stub_template 'groups/_group.html.erb' => '<p>groups/_group.html.erb</p>'
    @groups = Group.make(3)
  end

  let(:page) { Capybara.string rendered }

  it 'should have page title' do
    render
    page.should have_content(t('groups.index.title'))
  end

  it 'should render _group template for each group' do
    render
    page.should have_selector('#groups')
    page.all('#groups p', :text => 'groups/_group.html.erb').size.should eq(3)
  end

end
