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

ActiveRecord::Schema[7.0].define(version: 2023_01_19_231629) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "short_links", force: :cascade do |t|
    t.string "original_url", null: false
    t.string "slug", null: false
    t.integer "use_counter", default: 0
    t.integer "last_use"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["original_url"], name: "index_short_links_on_original_url", unique: true
    t.index ["slug"], name: "index_short_links_on_slug", unique: true
  end

end
