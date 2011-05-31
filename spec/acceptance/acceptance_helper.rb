require 'spec_helper'
require 'steak'

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

def login user = nil
  user ||= User.make!
  visit new_user_session_path
  fill_in t('activerecord.attributes.user.login'), :with => user.username
  fill_in t('activerecord.attributes.user.password'), :with => user.password
  click_link_or_button t('devise.sessions.new.submit')
end

#def select_date(field, options = {})
  #date     = Date.parse(options[:with])
  #selector = %Q{.//p[contains(./label, "#{field}")]}
  #within(:xpath, selector) do
    #find(:xpath, '//select[contains(@id, "_1i")]').find(:xpath, ::XPath::HTML.option(date.year.to_s)).select_option
    #find(:xpath, '//select[contains(@id, "_2i")]').find(:xpath, ::XPath::HTML.option(I18n.t('date.month_names')[date.month])).select_option
    #find(:xpath, '//select[contains(@id, "_3i")]').find(:xpath, ::XPath::HTML.option(date.day.to_s)).select_option
  #end
#end

#def select_time(field, options = {})
  #time     = Time.parse(options[:with])
  #selector = %Q{.//p[contains(./label, "#{field}")]}
  #within(:xpath, selector) do
    #find(:xpath, '//select[contains(@id, "_4i")]').find(:xpath, ::XPath::HTML.option(time.hour.to_s.rjust(2,'0'))).select_option
    #find(:xpath, '//select[contains(@id, "_5i")]').find(:xpath, ::XPath::HTML.option(time.min.to_s.rjust(2,'0'))).select_option
  #end
#end

#def select_datetime(field, options = {})
  #select_date(field, options)
  #select_time(field, options)
#end
