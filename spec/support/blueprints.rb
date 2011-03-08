require 'machinist/active_record'

User.blueprint do
  email { "john_#{sn}@gmail.com" }
  password { 'qwerty' }
  password_confirmation { 'qwerty' }
  username { "john_#{sn}" }
  confirmed_at { Date.today } 
end

Group.blueprint do
  name { "Group #{sn}" }
end
