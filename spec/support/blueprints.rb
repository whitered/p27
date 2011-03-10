require 'machinist/active_record'

User.blueprint do
  email { "john_#{sn}@gmail.com" }
  password { 'qwerty' }
  password_confirmation { 'qwerty' }
  username { "John_#{sn}" }
  confirmed_at { Date.today } 
end

Group.blueprint do
  name { "Group #{sn}" }
end

Membership.blueprint do
  user_id { 1 }
  group_id { 1 }
end
