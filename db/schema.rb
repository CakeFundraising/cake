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

ActiveRecord::Schema.define(version: 20150220200934) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "browsers", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token",       limit: 255
    t.string   "fingerprint", limit: 255
  end

  add_index "browsers", ["fingerprint"], name: "index_browsers_on_fingerprint", using: :btree
  add_index "browsers", ["token"], name: "index_browsers_on_token", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.string   "title",                limit: 255
    t.datetime "launch_date"
    t.datetime "end_date"
    t.string   "headline",             limit: 255
    t.text     "story"
    t.boolean  "custom_pledge_levels",             default: false
    t.integer  "fundraiser_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "causes_mask"
    t.integer  "scopes_mask"
    t.string   "status",               limit: 255, default: "incomplete"
    t.text     "mission"
    t.string   "processed_status",     limit: 255, default: "unprocessed"
    t.integer  "goal_cents",                       default: 0,             null: false
    t.string   "goal_currency",        limit: 255, default: "USD",         null: false
    t.string   "main_cause",           limit: 255
    t.integer  "impressions_count",    limit: 8,   default: 0
    t.boolean  "visible",                          default: false
    t.string   "screenshot_url",       limit: 255
    t.string   "screenshot_version",   limit: 255
    t.string   "sponsor_alias",        limit: 255, default: "Sponsors"
    t.boolean  "hero",                             default: true
    t.string   "url"
  end

  create_table "charges", force: :cascade do |t|
    t.string   "stripe_id",              limit: 255
    t.string   "balance_transaction_id", limit: 255
    t.string   "kind",                   limit: 255
    t.integer  "amount_cents",                       default: 0,     null: false
    t.string   "amount_currency",        limit: 255, default: "USD", null: false
    t.integer  "total_fee_cents",                    default: 0,     null: false
    t.string   "total_fee_currency",     limit: 255, default: "USD", null: false
    t.boolean  "paid"
    t.boolean  "captured"
    t.json     "fee_details"
    t.string   "chargeable_type",        limit: 255
    t.integer  "chargeable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "charges", ["balance_transaction_id"], name: "index_charges_on_balance_transaction_id", unique: true, using: :btree
  add_index "charges", ["stripe_id"], name: "index_charges_on_stripe_id", unique: true, using: :btree

  create_table "clicks", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.integer  "pledge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "browser_id"
    t.boolean  "bonus",                  default: false
  end

  create_table "coupons", force: :cascade do |t|
    t.string   "title",                       limit: 255
    t.datetime "expires_at"
    t.string   "promo_code",                  limit: 255
    t.text     "description"
    t.text     "terms_conditions"
    t.integer  "pledge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit_donation_cents",                     default: 0,     null: false
    t.string   "unit_donation_currency",      limit: 255, default: "USD", null: false
    t.integer  "total_donation_cents",                    default: 0,     null: false
    t.string   "total_donation_currency",     limit: 255, default: "USD", null: false
    t.boolean  "extra_donation_pledge",                   default: false
    t.integer  "merchandise_categories_mask", limit: 8
    t.string   "url",                         limit: 255
  end

  create_table "direct_donations", force: :cascade do |t|
    t.string   "email",           limit: 255
    t.string   "card_token",      limit: 255
    t.integer  "campaign_id"
    t.integer  "amount_cents",                default: 0,     null: false
    t.string   "amount_currency", limit: 255, default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fundraiser_id"
  end

  create_table "fr_sponsors", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "email",         limit: 255
    t.integer  "fundraiser_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fundraiser_email_settings", force: :cascade do |t|
    t.boolean  "new_pledge",              default: true
    t.boolean  "pledge_increased",        default: true
    t.boolean  "pledge_fully_subscribed", default: true
    t.boolean  "campaign_end",            default: true
    t.boolean  "missed_launch_campaign",  default: true
    t.boolean  "account_change",          default: true
    t.boolean  "public_profile_change",   default: true
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fundraisers", force: :cascade do |t|
    t.boolean  "donations_kind",                          default: false
    t.boolean  "tax_exempt",                              default: false
    t.boolean  "unsolicited_pledges",                     default: false
    t.string   "manager_name",                limit: 255
    t.string   "manager_title",               limit: 255
    t.string   "manager_email",               limit: 255
    t.string   "manager_phone",               limit: 255
    t.string   "name",                        limit: 255
    t.text     "mission"
    t.text     "supporter_demographics"
    t.string   "phone",                       limit: 255
    t.string   "website",                     limit: 255
    t.string   "email",                       limit: 255
    t.integer  "manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "causes_mask"
    t.integer  "min_pledge_cents",                        default: 0,     null: false
    t.string   "min_pledge_currency",         limit: 255, default: "USD", null: false
    t.integer  "min_click_donation_cents",                default: 0,     null: false
    t.string   "min_click_donation_currency", limit: 255, default: "USD", null: false
    t.string   "email_subscribers",           limit: 255
    t.string   "facebook_subscribers",        limit: 255
    t.string   "twitter_subscribers",         limit: 255
    t.string   "pinterest_subscribers",       limit: 255
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type", limit: 255
    t.integer  "impressionable_id"
    t.string   "view",                limit: 255
    t.boolean  "fully_rendered",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "browser_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "clicks",                  limit: 8
    t.integer  "click_donation_cents",                default: 0,            null: false
    t.string   "click_donation_currency", limit: 255, default: "USD",        null: false
    t.integer  "due_cents",               limit: 8
    t.string   "due_currency",            limit: 255, default: "USD",        null: false
    t.string   "status",                  limit: 255, default: "due_to_pay"
    t.integer  "pledge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                    limit: 255
  end

  create_table "locations", force: :cascade do |t|
    t.string   "address",        limit: 255
    t.string   "country_code",   limit: 255
    t.string   "state_code",     limit: 255
    t.string   "zip_code",       limit: 255
    t.string   "city",           limit: 255
    t.integer  "locatable_id"
    t.string   "locatable_type", limit: 255
    t.string   "name",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["locatable_id", "locatable_type"], name: "index_locations_on_locatable_id_and_locatable_type", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "total_cents",    limit: 8
    t.string   "total_currency", limit: 255, default: "USD",     null: false
    t.string   "kind",           limit: 255
    t.string   "item_type",      limit: 255
    t.integer  "item_id"
    t.string   "payer_type",     limit: 255
    t.integer  "payer_id"
    t.string   "recipient_type", limit: 255
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",         limit: 255, default: "charged"
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "avatar",          limit: 255
    t.string   "avatar_caption",  limit: 255
    t.string   "banner",          limit: 255
    t.string   "banner_caption",  limit: 255
    t.string   "picturable_type", limit: 255
    t.integer  "picturable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "avatar_crop_x"
    t.integer  "avatar_crop_y"
    t.integer  "avatar_crop_w"
    t.integer  "avatar_crop_h"
    t.integer  "banner_crop_x"
    t.integer  "banner_crop_y"
    t.integer  "banner_crop_w"
    t.integer  "banner_crop_h"
    t.string   "qrcode",          limit: 255
    t.integer  "qrcode_crop_x"
    t.integer  "qrcode_crop_y"
    t.integer  "qrcode_crop_w"
    t.integer  "qrcode_crop_h"
  end

  create_table "pledge_news", force: :cascade do |t|
    t.string   "headline"
    t.text     "story"
    t.string   "url"
    t.integer  "pledge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pledge_requests", force: :cascade do |t|
    t.integer  "sponsor_id"
    t.integer  "fundraiser_id"
    t.integer  "campaign_id"
    t.string   "status",        limit: 255, default: "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pledges", force: :cascade do |t|
    t.string   "mission",                   limit: 255
    t.string   "headline",                  limit: 255
    t.text     "description"
    t.integer  "amount_per_click_cents",                default: 0,             null: false
    t.string   "amount_per_click_currency", limit: 255, default: "USD",         null: false
    t.integer  "total_amount_cents",                    default: 0,             null: false
    t.string   "total_amount_currency",     limit: 255, default: "USD",         null: false
    t.string   "website_url",               limit: 255
    t.integer  "campaign_id"
    t.integer  "sponsor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",                    limit: 255, default: "incomplete"
    t.boolean  "show_coupons",                          default: false
    t.integer  "max_clicks",                            default: 0
    t.boolean  "increase_requested",                    default: false
    t.string   "processed_status",          limit: 255, default: "unprocessed"
    t.string   "name",                      limit: 255
    t.integer  "impressions_count",         limit: 8,   default: 0
    t.string   "screenshot_url",            limit: 255
    t.string   "screenshot_version",        limit: 255
    t.integer  "bonus_clicks_count",        limit: 8,   default: 0,             null: false
    t.integer  "clicks_count",              limit: 8,   default: 0,             null: false
    t.string   "type",                      limit: 255
    t.string   "sponsor_type",              limit: 255
  end

  create_table "sponsor_categories", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.integer  "min_value_cents",    limit: 8,   default: 0,     null: false
    t.string   "min_value_currency", limit: 255, default: "USD", null: false
    t.integer  "max_value_cents",    limit: 8,   default: 0,     null: false
    t.string   "max_value_currency", limit: 255, default: "USD", null: false
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                       default: 0
  end

  create_table "sponsor_email_settings", force: :cascade do |t|
    t.boolean  "new_pledge_request",      default: true
    t.boolean  "pledge_increased",        default: true
    t.boolean  "pledge_fully_subscribed", default: true
    t.boolean  "pledge_accepted",         default: true
    t.boolean  "pledge_rejected",         default: true
    t.boolean  "account_change",          default: true
    t.boolean  "public_profile_change",   default: true
    t.boolean  "campaign_launch",         default: true
    t.boolean  "campaign_end",            default: true
    t.boolean  "missed_launch_campaign",  default: true
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsors", force: :cascade do |t|
    t.text     "mission"
    t.text     "customer_demographics"
    t.string   "manager_name",            limit: 255
    t.string   "manager_title",           limit: 255
    t.string   "manager_email",           limit: 255
    t.string   "manager_phone",           limit: 255
    t.string   "name",                    limit: 255
    t.string   "phone",                   limit: 255
    t.string   "website",                 limit: 255
    t.string   "email",                   limit: 255
    t.integer  "cause_requirements_mask"
    t.integer  "scopes_mask"
    t.integer  "causes_mask"
    t.integer  "manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email_subscribers",       limit: 255
    t.string   "facebook_subscribers",    limit: 255
    t.string   "twitter_subscribers",     limit: 255
    t.string   "pinterest_subscribers",   limit: 255
  end

  create_table "stripe_accounts", force: :cascade do |t|
    t.string   "uid",                    limit: 255
    t.string   "stripe_publishable_key", limit: 255
    t.string   "token",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_recipient_id",    limit: 255
    t.string   "account_type",           limit: 255
    t.integer  "account_id"
    t.string   "stripe_customer_id",     limit: 255
  end

  add_index "stripe_accounts", ["uid"], name: "index_stripe_accounts_on_uid", unique: true, using: :btree

  create_table "subscriptors", force: :cascade do |t|
    t.string   "email"
    t.string   "object_type"
    t.integer  "object_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "phone"
    t.string   "organization"
    t.text     "message"
    t.string   "name"
    t.string   "origin_type"
    t.string   "origin_id"
  end

  create_table "sweepstakes", force: :cascade do |t|
    t.string   "title",                    limit: 255
    t.integer  "winners_quantity"
    t.text     "claim_prize_instructions"
    t.text     "description"
    t.text     "terms_conditions"
    t.string   "avatar",                   limit: 255
    t.integer  "pledge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transfers", force: :cascade do |t|
    t.string   "stripe_id",              limit: 255
    t.string   "balance_transaction_id", limit: 255
    t.string   "kind",                   limit: 255
    t.integer  "amount_cents",                       default: 0,     null: false
    t.string   "amount_currency",        limit: 255, default: "USD", null: false
    t.integer  "total_fee_cents",                    default: 0,     null: false
    t.string   "total_fee_currency",     limit: 255, default: "USD", null: false
    t.string   "status",                 limit: 255
    t.string   "transferable_type",      limit: 255
    t.integer  "transferable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "full_name",              limit: 255
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "auth_token",             limit: 255
    t.string   "auth_secret",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "roles_mask"
    t.integer  "fundraiser_id"
    t.integer  "sponsor_id"
    t.boolean  "registered",                         default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "recordable_type", limit: 255
    t.integer  "recordable_id"
    t.string   "url",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider",        limit: 255
    t.string   "thumbnail",       limit: 255
    t.boolean  "auto_show",                   default: true
  end

end
