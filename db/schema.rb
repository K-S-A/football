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

ActiveRecord::Schema.define(version: 20160429055046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assessments", force: :cascade do |t|
    t.integer  "score"
    t.integer  "user_id"
    t.integer  "rated_user_id", null: false
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "assessments", ["rated_user_id"], name: "index_assessments_on_rated_user_id", using: :btree
  add_index "assessments", ["tournament_id"], name: "index_assessments_on_tournament_id", using: :btree
  add_index "assessments", ["user_id", "rated_user_id", "tournament_id"], name: "index_assessments_on_user_and_tournament", unique: true, using: :btree
  add_index "assessments", ["user_id"], name: "index_assessments_on_user_id", using: :btree

  create_table "matches", force: :cascade do |t|
    t.integer  "round_id"
    t.integer  "host_score"
    t.integer  "guest_score"
    t.integer  "host_team_id"
    t.integer  "guest_team_id"
    t.integer  "next_id"
    t.integer  "grid"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "matches", ["guest_team_id"], name: "index_matches_on_guest_team_id", using: :btree
  add_index "matches", ["host_team_id"], name: "index_matches_on_host_team_id", using: :btree
  add_index "matches", ["next_id"], name: "index_matches_on_next_id", using: :btree
  add_index "matches", ["round_id"], name: "index_matches_on_round_id", using: :btree

  create_table "rounds", force: :cascade do |t|
    t.integer  "tournament_id"
    t.string   "mode",          default: "regular", null: false
    t.integer  "position",      default: 0,         null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "rounds", ["tournament_id"], name: "index_rounds_on_tournament_id", using: :btree

  create_table "rounds_teams", id: false, force: :cascade do |t|
    t.integer "team_id",  null: false
    t.integer "round_id", null: false
  end

  add_index "rounds_teams", ["round_id", "team_id"], name: "index_rounds_teams_on_round_id_and_team_id", using: :btree
  add_index "rounds_teams", ["team_id", "round_id"], name: "index_rounds_teams_on_team_id_and_round_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",          null: false
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "list_order"
  end

  add_index "teams", ["tournament_id"], name: "index_teams_on_tournament_id", using: :btree

  create_table "teams_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "team_id", null: false
  end

  add_index "teams_users", ["team_id", "user_id"], name: "index_teams_users_on_team_id_and_user_id", using: :btree
  add_index "teams_users", ["user_id", "team_id"], name: "index_teams_users_on_user_id_and_team_id", using: :btree

  create_table "tournaments", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "status",      default: "not started", null: false
    t.string   "sports_kind",                         null: false
    t.integer  "team_size",   default: 1,             null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "tournaments", ["name"], name: "index_tournaments_on_name", unique: true, using: :btree

  create_table "tournaments_users", id: false, force: :cascade do |t|
    t.integer "user_id",       null: false
    t.integer "tournament_id", null: false
  end

  add_index "tournaments_users", ["tournament_id", "user_id"], name: "index_tournaments_users_on_tournament_id_and_user_id", using: :btree
  add_index "tournaments_users", ["user_id", "tournament_id"], name: "index_tournaments_users_on_user_id_and_tournament_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "img_link"
    t.integer  "rank"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "assessments", "tournaments"
  add_foreign_key "assessments", "users"
  add_foreign_key "matches", "rounds"
  add_foreign_key "rounds", "tournaments"
  add_foreign_key "teams", "tournaments"
end
