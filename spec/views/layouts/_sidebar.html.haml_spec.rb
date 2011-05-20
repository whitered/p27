require 'spec_helper'

describe 'layouts/_sidebar' do

  before do
    stub_template 'groups/_group.html.haml' => '%div[group]'
  end

  let(:page) { Capybara.string rendered }

  it 'should render user groups' do
    @my_groups = Group.make!(2)
    render
    page.all('.group').size.should == 2
  end

  it 'should have link to my groups' do
    @my_groups = []
    render
    page.should have_link(t('layouts.sidebar.my_groups', :href => my_groups_path))
  end

end
