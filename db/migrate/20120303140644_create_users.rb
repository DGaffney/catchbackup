class CreateUsers < ActiveRecord::Migration
  def change
    create_table "user_position_metric_points", :force => true do |t|
      t.string   "key"
      t.string   "value"
      t.integer  "user_position_metric_id"
      t.integer  "user_id"
      t.datetime "created_at",              :null => false
      t.datetime "updated_at",              :null => false
    end

    add_index "user_position_metric_points", ["user_position_metric_id", "user_id", "key", "value"], :name => "unique_upmp", :unique => true

    create_table "user_position_metrics", :force => true do |t|
      t.string   "name"
      t.string   "metric_type"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end
  end
end
