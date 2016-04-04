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

ActiveRecord::Schema.define(version: 20160404122854) do

  create_table "matches", force: :cascade do |t|
    t.integer  "round_id"
    t.integer  "host_score"
    t.integer  "guest_score"
    t.integer  "host_team_id",  null: false
    t.integer  "guest_team_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "matches", ["round_id"], name: "index_matches_on_round_id"

  create_table "rounds", force: :cascade do |t|
    t.integer  "tournament_id"
    t.string   "type",          default: "regular", null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "rounds", ["tournament_id"], name: "index_rounds_on_tournament_id"

  create_table "teams", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "team_id", null: false
  end

  add_index "teams_users", ["team_id", "user_id"], name: "index_teams_users_on_team_id_and_user_id"
  add_index "teams_users", ["user_id", "team_id"], name: "index_teams_users_on_user_id_and_team_id"

  create_table "tournaments", force: :cascade do |t|
    t.string   "name",                               null: false
    t.string   "status",     default: "not started", null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "img_link"
    t.integer  "rank"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
