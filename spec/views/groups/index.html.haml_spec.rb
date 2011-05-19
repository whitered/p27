require 'spec_helper'

describe 'groups/index.html.haml' do

  before do 
    stub_template 'groups/_group.html.haml' => '<p>groups/_group.html.haml</p>'
    @groups = Group.make(3)
  end

  let(:page) { Capybara.string rendered }

  it 'should render _group template for each group' do
    render
    page.should have_selector('#groups')
    page.all('#groups p', :text => 'groups/_group.html.haml').size.should eq(3)
  end

  context 'for logged in user' do

    before do 
      sign_in User.make!
    end

  end

  context 'for not logged in user' do

    it 'should not have new group link' do
      render
      page.should have_no_link(t('groups.index.new_group'))
    end

  end

end
