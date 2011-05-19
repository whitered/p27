require 'spec_helper'

describe 'groups/new.html.haml' do

  let(:page) { Capybara.string rendered }

  before do
    @group = Group.new
  end

  it 'should have group name field' do
    render
    page.should have_field(t('activerecord.attributes.group.name'))
  end

  it 'should have submit button' do
    render
    page.should have_button(t('groups.new.submit'))
  end

  it 'should render errors for name field' do
    @group.errors.add :name
    render
    page.should have_content(t_error(Group, :name))
  end

end
