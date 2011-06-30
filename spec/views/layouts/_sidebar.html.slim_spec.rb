require 'spec_helper'

describe 'layouts/_sidebar' do

  subject do
    stub_template 'groups/_group.html.slim' => 'div class="group"'
    render 'layouts/sidebar', :my_groups => Group.make(2)
    Capybara.string rendered
  end

  it 'should render user groups' do
    subject.all('.group').size.should == 2
  end

  it { should have_link(t('layouts.sidebar.my_groups', :href => my_groups_path)) }

end
