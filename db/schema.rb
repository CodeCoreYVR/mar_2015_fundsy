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

ActiveRecord::Schema.define(version: 20150507164659) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaigns", force: :cascade do |t|
    t.string   "title"
    t.integer  "goal"
    t.text     "description"
    t.datetime "ends_on"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.string   "aasm_state"
    t.string   "address"
    t.float    "longitude"
    t.float    "latitude"
  end

  add_index "campaigns", ["aasm_state"], name: "index_campaigns_on_aasm_state", using: :btree
  add_index "campaigns", ["user_id"], name: "index_campaigns_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree

  create_table "discussions", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "discussions", ["user_id"], name: "index_discussions_on_user_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "groups", ["user_id"], name: "index_groups_on_user_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "email"
    t.boolean  "approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "pledges", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "aasm_state"
    t.string   "stripe_txn_id"
  end

  add_index "pledges", ["campaign_id"], name: "index_pledges_on_campaign_id", using: :btree
  add_index "pledges", ["user_id"], name: "index_pledges_on_user_id", using: :btree

  create_table "reward_levels", force: :cascade do |t|
    t.integer  "campaign_id"
    t.integer  "amount"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "reward_levels", ["campaign_id"], name: "index_reward_levels_on_campaign_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "address"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "api_key"
    t.string   "stripe_customer_token"
    t.string   "stripe_last4"
    t.string   "stripe_card_type"
  end

  add_index "users", ["api_key"], name: "index_users_on_api_key", using: :btree

  add_foreign_key "campaigns", "users"
  add_foreign_key "discussions", "users"
  add_foreign_key "groups", "users"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "pledges", "campaigns"
  add_foreign_key "pledges", "users"
  add_foreign_key "reward_levels", "campaigns"
end
