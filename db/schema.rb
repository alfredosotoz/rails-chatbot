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

ActiveRecord::Schema.define(version: 20170126021904) do

  create_table "logs", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "fb_message_id"
    t.string   "message_type"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sources", force: :cascade do |t|
    t.string   "name"
    t.string   "api_id"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "fb_id"
    t.string   "full_name"
    t.string   "gender"
    t.string   "locale"
    t.integer  "timezone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
