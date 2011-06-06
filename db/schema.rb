# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110531135313) do

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.text     "body",             :default => ""
    t.integer  "user_id",          :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["parent_id"], :name => "index_comments_on_parent_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "games", :force => true do |t|
    t.integer  "announcer_id"
    t.integer  "group_id"
    t.text     "description"
    t.string   "place"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "buyin",        :default => 0,     :null => false
    t.integer  "rebuy",        :default => 0,     :null => false
    t.integer  "addon",        :default => 0,     :null => false
    t.boolean  "archived",     :default => false, :null => false
  end

  add_index "games", ["announcer_id"], :name => "index_games_on_announcer_id"
  add_index "games", ["group_id"], :name => "index_games_on_group_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.boolean  "private",    :default => false, :null => false
    t.boolean  "hospitable", :default => true,  :null => false
  end

  add_index "groups", ["owner_id"], :name => "index_groups_on_owner_id"

  create_table "invitations", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.integer  "group_id"
    t.integer  "inviter_id"
    t.string   "message"
    t.integer  "membership_id"
    t.boolean  "declined",      :default => false, :null => false
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["group_id"], :name => "index_invitations_on_group_id"
  add_index "invitations", ["inviter_id"], :name => "index_invitations_on_inviter_id"
  add_index "invitations", ["membership_id"], :name => "index_invitations_on_membership_id"
  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "is_admin",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inviter_id"
  end

  add_index "memberships", ["group_id"], :name => "index_memberships_on_group_id"
  add_index "memberships", ["inviter_id"], :name => "index_memberships_on_inviter_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rebuys",     :default => 0,     :null => false
    t.boolean  "addon",      :default => false, :null => false
    t.integer  "place"
    t.integer  "win"
    t.string   "dummy_name"
  end

  add_index "participations", ["game_id"], :name => "index_participations_on_game_id"
  add_index "participations", ["user_id"], :name => "index_participations_on_user_id"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "author_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comment_threads_count", :default => 0
  end

  add_index "posts", ["author_id"], :name => "index_posts_on_author_id"
  add_index "posts", ["group_id"], :name => "index_posts_on_group_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "username",                                            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "visits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "visitable_id"
    t.string   "visitable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "existing_comments", :default => 0, :null => false
  end

  add_index "visits", ["user_id"], :name => "index_visits_on_user_id"
  add_index "visits", ["visitable_id", "visitable_type"], :name => "index_visits_on_visitable_id_and_visitable_type"

end
