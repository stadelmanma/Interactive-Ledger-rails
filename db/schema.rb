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

ActiveRecord::Schema.define(version: 20171014025103) do

  create_table "budget_expenses", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date "date"
    t.string "description"
    t.float "amount", limit: 24
    t.text "comments"
    t.integer "budget_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_id"], name: "index_budget_expenses_on_budget_id"
  end

  create_table "budget_ledgers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "budget_id"
    t.integer "ledger_id"
    t.index ["budget_id"], name: "index_budget_ledgers_on_budget_id"
    t.index ["ledger_id"], name: "index_budget_ledgers_on_ledger_id"
  end

  create_table "budgets", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.float "initial_balance", limit: 24, default: 0.0
  end

  create_table "category_exclusions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "ledger_id"
    t.string "category", null: false
    t.string "excluded_from", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["excluded_from"], name: "index_category_exclusions_on_excluded_from", type: :fulltext
    t.index ["ledger_id"], name: "index_category_exclusions_on_ledger_id"
  end

  create_table "category_initializers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "pattern", null: false
    t.string "category"
    t.string "subcategory"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", default: 0
  end

  create_table "ledger_uploads", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "ledger_id"
    t.string "data_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "uploaded"
    t.index ["ledger_id"], name: "index_ledger_uploads_on_ledger_id"
  end

  create_table "ledgers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "ledger_id"
    t.date "date"
    t.string "description"
    t.float "amount", limit: 24
    t.boolean "validated"
    t.string "category"
    t.string "subcategory"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "balance", limit: 24
    t.string "account"
    t.integer "ledger_upload_id"
    t.index ["category"], name: "index_transactions_on_category", type: :fulltext
    t.index ["ledger_id"], name: "index_transactions_on_ledger_id"
    t.index ["ledger_upload_id"], name: "index_transactions_on_ledger_upload_id"
  end

  add_foreign_key "budget_expenses", "budgets"
  add_foreign_key "budget_ledgers", "budgets"
  add_foreign_key "budget_ledgers", "ledgers"
  add_foreign_key "category_exclusions", "ledgers"
  add_foreign_key "ledger_uploads", "ledgers"
  add_foreign_key "transactions", "ledger_uploads"
  add_foreign_key "transactions", "ledgers"
end
