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

ActiveRecord::Schema.define(version: 2019_10_12_202553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "character_classes", force: :cascade do |t|
    t.jsonb "name", default: {"en"=>"", "ru"=>""}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_character_classes_on_name", using: :gin
  end

  create_table "characters", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "level", default: 60, null: false
    t.integer "race_id"
    t.integer "character_class_id"
    t.integer "user_id"
    t.integer "world_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "guild_id"
    t.index ["character_class_id"], name: "index_characters_on_character_class_id"
    t.index ["guild_id"], name: "index_characters_on_guild_id"
    t.index ["name"], name: "index_characters_on_name"
    t.index ["race_id"], name: "index_characters_on_race_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
    t.index ["world_id"], name: "index_characters_on_world_id"
  end

  create_table "fractions", force: :cascade do |t|
    t.jsonb "name", default: {"en"=>"", "ru"=>""}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_fractions_on_name", using: :gin
  end

  create_table "guilds", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "world_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_guilds_on_name"
    t.index ["world_id"], name: "index_guilds_on_world_id"
  end

  create_table "races", force: :cascade do |t|
    t.jsonb "name", default: {"en"=>"", "ru"=>""}, null: false
    t.integer "fraction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fraction_id"], name: "index_races_on_fraction_id"
    t.index ["name"], name: "index_races_on_name", using: :gin
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "user", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "worlds", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "zone", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_worlds_on_name"
  end

end
