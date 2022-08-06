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

ActiveRecord::Schema[7.0].define(version: 2022_08_06_051759) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "parent_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["parent_category_id"], name: "index_categories_on_parent_category_id"
  end

  create_table "eat_plan_categories", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "eat_plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id", "eat_plan_id"], name: "index_eat_plan_categories_on_category_id_and_eat_plan_id", unique: true
    t.index ["eat_plan_id"], name: "index_eat_plan_categories_on_eat_plan_id"
  end

  create_table "eat_plans", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "status", default: "draft"
    t.string "duration_metric"
    t.integer "duration_value"
    t.integer "meals_per_day"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_eat_plans_on_name"
    t.index ["user_id", "name"], name: "index_eat_plans_on_user_id_and_name", unique: true
  end

  add_foreign_key "categories", "categories", column: "parent_category_id"
  add_foreign_key "eat_plan_categories", "categories"
  add_foreign_key "eat_plan_categories", "eat_plans"
end
