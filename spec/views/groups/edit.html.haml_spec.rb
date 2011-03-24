require 'spec_helper'

describe 'groups/edit.html.haml' do

  before do
    @group = Group.make!
    render
  end

  let(:page) { Capybara.string rendered }

  it 'should have page title' do
    page.should have_content(t('groups.edit.title'))
  end

  it 'should have group name field' do
    page.should have_field(t('activerecord.attributes.group.name'), :with => @group.name)
  end

  it 'should have private checkbox' do
    page.should have_field(t('activerecord.attributes.group.private'))
    page.find_field(t('activerecord.attributes.group.private'))[:checked].should eq(false)
  end

  it 'should have hospitable checkbox' do
    page.should have_field(t('activerecord.attributes.group.hospitable'))
    page.find_field(t('activerecord.attributes.group.hospitable'))[:checked].should eq(true)
  end

  it 'should have commit button' do
    page.should have_button(t('groups.edit.commit'))
  end
end
