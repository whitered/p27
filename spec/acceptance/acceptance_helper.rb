require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "steak"

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

def login user = nil
  user ||= User.make!
  visit new_user_session_path
  fill_in t('activerecord.attributes.user.login'), :with => user.username
  fill_in t('activerecord.attributes.user.password'), :with => user.password
  click_link_or_button t('devise.sessions.new.commit')
end
