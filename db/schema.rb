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

ActiveRecord::Schema.define(version: 20181017001116) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "competition_players", id: :serial, force: :cascade do |t|
    t.integer "competition_id"
    t.integer "player_id"
  end

  create_table "competitions", id: :serial, force: :cascade do |t|
    t.integer "game_id"
    t.string "name"
    t.datetime "start_date"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "score_as_of_round", default: 0
    t.integer "season_id"
    t.date "end_date"
    t.text "about"
    t.index ["slug"], name: "index_competitions_on_slug", unique: true
  end

  create_table "drafts", id: :serial, force: :cascade do |t|
    t.integer "league_id"
    t.datetime "start_time"
    t.integer "rounds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: false, null: false
    t.boolean "completed", default: false, null: false
  end

  create_table "games", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "category", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_games_on_slug", unique: true
  end

  create_table "invites", id: :serial, force: :cascade do |t|
    t.string "token"
    t.integer "league_id"
    t.boolean "accepted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.index ["token"], name: "index_invites_on_token", unique: true
  end

  create_table "league_users", id: :serial, force: :cascade do |t|
    t.integer "league_id"
    t.integer "user_id"
    t.boolean "confirmed", default: false, null: false
  end

  create_table "leagues", id: :serial, force: :cascade do |t|
    t.integer "leagueable_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "leagueable_type"
    t.integer "num_draft_rounds", default: 6
    t.boolean "public", default: false
    t.integer "draft_type"
    t.string "name"
    t.index ["leagueable_type", "leagueable_id"], name: "index_leagues_on_leagueable_type_and_leagueable_id"
  end

  create_table "picks", id: :serial, force: :cascade do |t|
    t.integer "draft_id"
    t.integer "team_id"
    t.integer "player_id"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_records", force: :cascade do |t|
    t.integer "player_id"
    t.string "competition_name"
    t.string "competition_record"
    t.string "competition_format"
  end

  create_table "players", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "team"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "elo"
    t.integer "top_25_ranking"
    t.integer "power_ranking"
    t.integer "points"
    t.datetime "stats_updated_at"
    t.string "gp_record"
    t.string "pt_record"
    t.string "stats_url"
    t.text "bio"
    t.integer "player_type", default: 0
  end

  create_table "results", id: :serial, force: :cascade do |t|
    t.integer "player_id"
    t.integer "competition_id"
    t.integer "game_id"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "place"
    t.index ["player_id"], name: "index_results_on_player_id"
  end

  create_table "seasons", id: :serial, force: :cascade do |t|
    t.integer "game_id"
    t.string "name"
    t.string "slug"
    t.date "start_date"
    t.date "end_date"
    t.index ["slug"], name: "index_seasons_on_slug", unique: true
  end

  create_table "stars", force: :cascade do |t|
    t.integer "draft_id"
    t.integer "team_id"
    t.integer "player_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "league_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "points"
    t.boolean "submitted", default: false
    t.datetime "submitted_at"
    t.string "supporting"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
