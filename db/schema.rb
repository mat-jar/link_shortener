# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_01_25_213013) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "og_tags", force: :cascade do |t|
    t.string "property", null: false
    t.string "content", null: false
    t.bigint "short_link_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property", "short_link_id"], name: "index_og_tags_on_property_and_short_link_id", unique: true
    t.index ["short_link_id"], name: "index_og_tags_on_short_link_id"
  end

  create_table "short_links", force: :cascade do |t|
    t.string "original_url", null: false
    t.string "slug", null: false
    t.integer "use_counter", default: 0
    t.integer "last_use"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["original_url", "user_id"], name: "index_short_links_on_original_url_and_user_id", unique: true
    t.index ["slug"], name: "index_short_links_on_slug", unique: true
    t.index ["user_id"], name: "index_short_links_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "og_tags", "short_links"
  add_foreign_key "short_links", "users"
end
