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

ActiveRecord::Schema.define(version: 20170611204427) do

  create_table "budget_expenses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.string   "description"
    t.float    "amount",      limit: 24
    t.text     "comments",    limit: 65535
    t.integer  "budget_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["budget_id"], name: "index_budget_expenses_on_budget_id", using: :btree
  end

  create_table "budget_ledgers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "budget_id"
    t.integer "ledger_id"
    t.index ["budget_id"], name: "index_budget_ledgers_on_budget_id", using: :btree
    t.index ["ledger_id"], name: "index_budget_ledgers_on_ledger_id", using: :btree
  end

  create_table "budgets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
  end

  create_table "ledger_uploads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "ledger_id"
    t.string   "data_source"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "uploaded"
    t.index ["ledger_id"], name: "index_ledger_uploads_on_ledger_id", using: :btree
  end

  create_table "ledgers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "ledger_id"
    t.date     "date"
    t.string   "description"
    t.float    "amount",           limit: 24
    t.boolean  "validated"
    t.string   "category"
    t.string   "subcategory"
    t.text     "comments",         limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.float    "balance",          limit: 24
    t.string   "account"
    t.integer  "ledger_upload_id"
    t.index ["ledger_id"], name: "index_transactions_on_ledger_id", using: :btree
    t.index ["ledger_upload_id"], name: "index_transactions_on_ledger_upload_id", using: :btree
  end

  add_foreign_key "budget_expenses", "budgets"
  add_foreign_key "budget_ledgers", "budgets"
  add_foreign_key "budget_ledgers", "ledgers"
  add_foreign_key "ledger_uploads", "ledgers"
end
