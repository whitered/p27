require 'spec_helper'

describe 'layouts/_authentication' do

  let(:page) { Capybara.string rendered }
  let(:authentication) { page.find '#authentication' }

  context 'for guest' do

    before do
      render
    end

    it 'should have login link' do
      authentication.should have_link(t('authentication.login'), 
                                      :href => new_user_session_path)
    end

    it 'should have registration link' do
      authentication.should have_link(t('authentication.registration'), 
                                        :href => new_user_registration_path)
    end

    #it 'should not have profile link' do
      #authentication.should_not have_xpath("//a[@href = '#{user_profile_path}']")
    #end

    it 'should not have logout link' do
      authentication.should_not have_xpath(".//a[@href='#{destroy_user_session_path}']")
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
      authentication.should have_link(t('authentication.logout'),
                                      :href => destroy_user_session_path)
    end

    it 'should not have login link' do
      authentication.should_not have_xpath(".//a[@href='#{new_user_session_path}']")
    end

    it 'should not have registration link' do
      authentication.should_not have_xpath(".//a[@href = '#{new_user_registration_path}']")
    end

  end

end

