require 'spec_helper'

describe 'groups/edit' do

  before do
    @group = Group.make!
    render
  end

  def content_for name
    view.instance_variable_get(:@_content_for)[name]
  end

  let(:page) { Capybara.string rendered }

  it 'should have group name in title prefix' do
    content_for(:title_prefix).should include(@group.name)
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

  it 'should have submit button' do
    page.should have_button(t('groups.edit.submit'))
  end
end
