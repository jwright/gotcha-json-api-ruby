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

ActiveRecord::Schema.define(version: 20180425113154) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arenas", force: :cascade do |t|
    t.string "location_name"
    t.string "street_address1"
    t.string "street_address2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", force: :cascade do |t|
    t.bigint "player_id"
    t.string "token"
    t.datetime "registered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_devices_on_player_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "seeker_id"
    t.bigint "opponent_id"
    t.datetime "matched_at"
    t.bigint "arena_id"
    t.datetime "found_at"
    t.datetime "ignored_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "pending_at"
    t.index ["arena_id"], name: "index_matches_on_arena_id"
    t.index ["opponent_id"], name: "index_matches_on_opponent_id"
    t.index ["seeker_id"], name: "index_matches_on_seeker_id"
  end

  create_table "player_arenas", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "arena_id"
    t.datetime "joined_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arena_id"], name: "index_player_arenas_on_arena_id"
    t.index ["player_id"], name: "index_player_arenas_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "crypted_password", null: false
    t.string "salt", null: false
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_key"
    t.string "name", null: false
  end

  create_table "scores", force: :cascade do |t|
    t.bigint "arena_id"
    t.bigint "player_id"
    t.integer "points"
    t.datetime "scored_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arena_id"], name: "index_scores_on_arena_id"
    t.index ["player_id"], name: "index_scores_on_player_id"
  end

  add_foreign_key "devices", "players"
  add_foreign_key "matches", "arenas"
  add_foreign_key "matches", "players", column: "opponent_id"
  add_foreign_key "matches", "players", column: "seeker_id"
  add_foreign_key "player_arenas", "arenas"
  add_foreign_key "player_arenas", "players"
  add_foreign_key "scores", "arenas"
  add_foreign_key "scores", "players"
end
