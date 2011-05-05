require 'spec_helper'

describe 'layouts/_header' do

  let(:page) { Capybara.string rendered }
  let(:authentication) { page.find '#authentication' }

  context 'for any visitor' do
    before do
      render
    end

    it 'should have link to home page' do
      page.should have_xpath(".//a[@href='#{root_path}']")
    end

    it 'should have link to groups' do
      page.should have_link(t('layouts.header.groups'), :href => groups_path)
    end

    it 'should have link to posts' do
      page.should have_link(t('layouts.header.posts'), :href => posts_path)
    end

    it 'should have link to games' do
      page.should have_link(t('layouts.header.games'), :href => games_path)
    end
  end

  context 'for guest' do

    before do
      render
    end

    it 'should have login link' do
      authentication.should have_link(t('layouts.header.login'), 
                                      :href => new_user_session_path)
    end

    it 'should have registration link' do
      authentication.should have_link(t('layouts.header.registration'), 
                                        :href => new_user_registration_path)
    end

    #it 'should not have profile link' do
      #authentication.should have_no_xpath("//a[@href = '#{user_profile_path}']")
    #end

    it 'should not have logout link' do
      authentication.should have_no_xpath(".//a[@href='#{destroy_user_session_path}']")
    end

  end

  context 'for user' do

    before do
      @view.should_receive(:user_signed_in?).and_return(true)
      render
    end

    #it 'should have profile link' do
      #authentication.should have_link(t('authentication.profile'),
                                      #:href => user_profile_path)
    #end

    it 'should have logout link' do
      authentication.should have_link(t('layouts.header.logout'),
                                      :href => destroy_user_session_path)
    end

    it 'should not have login link' do
      authentication.should have_no_xpath(".//a[@href='#{new_user_session_path}']")
    end

    it 'should not have registration link' do
      authentication.should have_no_xpath(".//a[@href = '#{new_user_registration_path}']")
    end

  end

end

