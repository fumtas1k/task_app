ActiveRecord::Schema.define(version: 2022_02_02_092357) do

  enable_extension "plpgsql"

  create_table "tasks", force: :cascade do |t|
    t.string "name", limit: 30, null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "expired_at", default: -> { "now()" }, null: false
  end

end
