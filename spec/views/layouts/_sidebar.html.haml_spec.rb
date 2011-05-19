require 'spec_helper'

describe 'layouts/_sidebar' do

  before do
    stub_template 'groups/_group.html.haml' => '%div[group]'
  end

  let(:page) { Capybara.string rendered }

  context 'for logged in user' do

    before do
      @user = User.make!
      sign_in @user
    end

    it 'should render user groups' do
      @user.groups << Group.make!(2)
      render
      page.all('.group').size.should == 2
    end
  end
end
