require 'spec_helper'

describe "home/index.html.erb" do

  let(:page) { Capybara.string rendered }

  context 'for guest' do

    before(:each) do
      render
    end

    it 'should show welcome' do
      page.should have_content(t('home.index.welcome'))
    end

    it 'should not have new_group link' do
      page.should have_no_link('', :href => new_group_path)
    end

  end

  context 'for user' do

    before do
      @view.stub(:user_signed_in?).and_return(true)
      render
    end

    it 'should have new_group link' do
      page.should have_link(t('groups.new.link'), :href => new_group_path)
    end

  end

end
