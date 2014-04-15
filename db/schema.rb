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

ActiveRecord::Schema.define(version: 20140415153751) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "campaigns", force: true do |t|
    t.string   "title"
    t.datetime "launch_date"
    t.datetime "end_date"
    t.string   "cause"
    t.string   "scope"
    t.string   "headline"
    t.text     "story"
    t.boolean  "no_sponsor_categories", default: false
    t.string   "status",                default: "private"
    t.integer  "fundraiser_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_settings", force: true do |t|
    t.boolean  "new_pledge",              default: false
    t.boolean  "pledge_increased",        default: false
    t.boolean  "pledge_fully_subscribed", default: false
    t.boolean  "campaign_end",            default: false
    t.boolean  "missed_launch_campaign",  default: false
    t.boolean  "account_change",          default: false
    t.boolean  "public_profile_change",   default: false
    t.boolean  "campaign_result_summary", default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fundraisers", force: true do |t|
    t.string   "cause"
    t.integer  "min_pledge"
    t.integer  "min_click_donation"
    t.boolean  "donations_kind",         default: false
    t.boolean  "tax_exempt",             default: false
    t.boolean  "unsolicited_pledges",    default: false
    t.string   "manager_name"
    t.string   "manager_title"
    t.string   "manager_email"
    t.string   "manager_phone"
    t.string   "name"
    t.text     "mission"
    t.text     "supporter_demographics"
    t.string   "phone"
    t.string   "website"
    t.string   "email"
    t.integer  "manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "address"
    t.string   "country_code"
    t.string   "state_code"
    t.string   "zip_code"
    t.string   "city"
    t.integer  "locatable_id"
    t.string   "locatable_type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["locatable_id", "locatable_type"], name: "index_locations_on_locatable_id_and_locatable_type", using: :btree

  create_table "pictures", force: true do |t|
    t.string   "avatar"
    t.string   "avatar_caption"
    t.string   "banner"
    t.string   "banner_caption"
    t.string   "picturable_type"
    t.integer  "picturable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsor_categories", force: true do |t|
    t.string   "name"
    t.integer  "min_value_cents",    default: 0,     null: false
    t.string   "min_value_currency", default: "USD", null: false
    t.integer  "max_value_cents",    default: 0,     null: false
    t.string   "max_value_currency", default: "USD", null: false
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsors", force: true do |t|
    t.text     "mission"
    t.text     "customer_demographics"
    t.string   "manager_name"
    t.string   "manager_title"
    t.string   "manager_email"
    t.string   "manager_phone"
    t.string   "name"
    t.string   "phone"
    t.string   "website"
    t.string   "email"
    t.integer  "cause_requirements_mask"
    t.integer  "scopes_mask"
    t.integer  "causes_mask"
    t.integer  "manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "full_name"
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "auth_token"
    t.string   "auth_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "roles_mask"
    t.integer  "fundraiser_id"
    t.integer  "sponsor_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree

  create_table "videos", force: true do |t|
    t.string   "recordable_type"
    t.integer  "recordable_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
