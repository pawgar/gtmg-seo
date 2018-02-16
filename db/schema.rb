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

ActiveRecord::Schema.define(version: 20180202125459) do

  create_table "client_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_role",  default: 0
    t.index ["client_id"], name: "index_client_users_on_client_id", using: :btree
    t.index ["user_id"], name: "index_client_users_on_user_id", using: :btree
  end

  create_table "clients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",          limit: 100
    t.string   "notes",         limit: 9999
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "code",          limit: 5
    t.integer  "ga_profile_id"
    t.index ["name"], name: "index_clients_on_user_id", using: :btree
  end

  create_table "efforts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "strategy_id"
    t.integer  "client_id"
    t.datetime "date"
    t.text     "status_url",     limit: 65535
    t.integer  "user_id"
    t.string   "qa",             limit: 9999
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "notes",          limit: 5000
    t.string   "feedback_token", limit: 100
    t.index ["client_id"], name: "index_efforts_on_client_id", using: :btree
    t.index ["strategy_id"], name: "index_efforts_on_strategy_id", using: :btree
    t.index ["user_id"], name: "index_efforts_on_user_id", using: :btree
  end

  create_table "kpi_objectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",      limit: 2000
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "kpis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "client_id"
    t.datetime "date"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "kpi_value",        limit: 65535
    t.integer  "kpi_objective_id"
    t.index ["client_id"], name: "index_kpis_on_client_id", using: :btree
    t.index ["kpi_objective_id"], name: "index_kpis_on_kpi_objective_id", using: :btree
  end

  create_table "krms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "client_id"
    t.string   "keywords",   limit: 1000
    t.datetime "date"
    t.string   "page_rank",  limit: 1000
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["client_id"], name: "index_krms_on_client_id", using: :btree
  end

  create_table "monthly_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "client_id"
    t.datetime "date"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "report_file_file_name"
    t.string   "report_file_content_type"
    t.integer  "report_file_file_size"
    t.datetime "report_file_updated_at"
    t.index ["client_id"], name: "index_monthly_reports_on_client_id", using: :btree
  end

  create_table "offpage_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code_letter"
    t.string   "category_name", limit: 5999
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "qa_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "effort_id"
    t.text     "comment",    limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["effort_id"], name: "index_qa_comments_on_effort_id", using: :btree
    t.index ["user_id"], name: "index_qa_comments_on_user_id", using: :btree
  end

  create_table "sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "session_id",               null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "social_auths", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "strategies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code",        limit: 200
    t.string   "description", limit: 9999
    t.string   "notes",       limit: 9999
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "strategy_offpage_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "offpage_category_id"
    t.integer  "strategy_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["offpage_category_id"], name: "index_strategy_offpage_categories_on_offpage_category_id", using: :btree
    t.index ["strategy_id"], name: "index_strategy_offpage_categories_on_strategy_id", using: :btree
  end

  create_table "tech_strategy_implementations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "technical_strategy_id"
    t.integer  "status"
    t.text     "comments",              limit: 65535
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "client_id"
    t.index ["client_id"], name: "index_tech_strategy_implementations_on_client_id", using: :btree
    t.index ["technical_strategy_id"], name: "index_tech_strategy_implementations_on_technical_strategy_id", using: :btree
  end

  create_table "technical_strategies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "notes",       limit: 65535
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "uploads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "effort_file_file_name"
    t.string   "effort_file_content_type"
    t.integer  "effort_file_file_size"
    t.datetime "effort_file_updated_at"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "firstname",           limit: 50
    t.string   "lastname",            limit: 50
    t.string   "email",               limit: 50
    t.string   "password_digest"
    t.integer  "status",                          default: 1
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "role",                            default: 2
    t.string   "reset_token",         limit: 100
    t.datetime "token_sent_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_foreign_key "client_users", "clients"
  add_foreign_key "client_users", "users"
  add_foreign_key "efforts", "clients"
  add_foreign_key "efforts", "strategies", name: "FK_efforts_strategies"
  add_foreign_key "efforts", "users"
  add_foreign_key "kpis", "clients"
  add_foreign_key "kpis", "kpi_objectives"
  add_foreign_key "krms", "clients"
  add_foreign_key "monthly_reports", "clients"
  add_foreign_key "qa_comments", "efforts"
  add_foreign_key "qa_comments", "users"
  add_foreign_key "strategy_offpage_categories", "offpage_categories"
  add_foreign_key "strategy_offpage_categories", "strategies"
  add_foreign_key "tech_strategy_implementations", "clients"
  add_foreign_key "tech_strategy_implementations", "technical_strategies"
end
