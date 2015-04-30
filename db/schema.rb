# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150430215029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "leavers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "match_id"
    t.integer  "rating_loss"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "match_tokens", force: :cascade do |t|
    t.integer  "match_id"
    t.integer  "user_id"
    t.string   "result"
    t.boolean  "captain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "steam_id"
    t.integer  "radiant_team_id"
    t.integer  "dire_team_id"
    t.string   "password"
    t.string   "name"
    t.string   "status",              default: "waiting"
    t.integer  "rating_differential"
    t.integer  "creator_id"
    t.boolean  "winner_team"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "teams", force: :cascade do |t|
    t.integer  "captain_id"
    t.string   "side"
    t.integer  "match_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
  end

  add_index "teams_users", ["team_id"], name: "index_teams_users_on_team_id", using: :btree
  add_index "teams_users", ["user_id"], name: "index_teams_users_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "steam_id"
    t.string   "name"
    t.string   "status",                 default: "unvouched"
    t.integer  "rating",                 default: 3500
    t.integer  "win_count",              default: 0
    t.integer  "lose_count",             default: 0
    t.integer  "leave_count",            default: 0
    t.integer  "team_id"
    t.integer  "match_id"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "email",                  default: "",                         null: false
    t.string   "encrypted_password",     default: "",                         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.boolean  "admin",                  default: false
    t.string   "real_name"
    t.string   "real_middle_name"
    t.string   "real_last_name"
    t.string   "gender"
    t.integer  "timezone"
    t.string   "facebook_link"
    t.boolean  "donator"
    t.integer  "donation_count"
    t.text     "description",            default: "Usuario sin descripción."
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
