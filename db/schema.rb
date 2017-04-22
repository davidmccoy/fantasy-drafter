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

ActiveRecord::Schema.define(version: 20170422023933) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "competition_players", force: :cascade do |t|
    t.integer "competition_id"
    t.integer "player_id"
  end

  create_table "competitions", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "name"
    t.datetime "date"
    t.string   "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drafts", force: :cascade do |t|
    t.integer  "league_id"
    t.datetime "start_time"
    t.integer  "rounds"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "active",     default: false, null: false
    t.boolean  "completed",  default: false, null: false
  end

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.integer  "category",   default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "invites", force: :cascade do |t|
    t.string   "token"
    t.integer  "league_id"
    t.integer  "inviting_user_id"
    t.integer  "invited_user_id"
    t.boolean  "accepted",         default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "email"
    t.index ["token"], name: "index_invites_on_token", unique: true, using: :btree
  end

  create_table "league_users", force: :cascade do |t|
    t.integer "league_id"
    t.integer "user_id"
    t.boolean "confirmed", default: false, null: false
  end

  create_table "leagues", force: :cascade do |t|
    t.integer  "leagueable_id"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "leagueable_type"
    t.index ["leagueable_type", "leagueable_id"], name: "index_leagues_on_leagueable_type_and_leagueable_id", using: :btree
  end

  create_table "picks", force: :cascade do |t|
    t.integer  "draft_id"
    t.integer  "team_id"
    t.integer  "player_id"
    t.integer  "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.string   "team"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seasons", force: :cascade do |t|
    t.integer "game_id"
    t.string  "name"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "league_user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
