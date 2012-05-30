class CreateCore < ActiveRecord::Migration
  def change
    create_table "sources", :force => true do |t|
      t.string   "title"
      t.string   "location"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "articles", :force => true do |t|
      t.string   "title"
      t.string   "url"
      t.string   "author"
      t.text     "abstract"
      t.integer  "source_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "position_metrics", :force => true do |t|
      t.string   "name"
      t.integer  "metric_type"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "position_metric_points", :force => true do |t|
      t.string   "key"
      t.integer  "value"
      t.integer  "position_metric_id"
      t.integer  "article_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "importance_metrics", :force => true do |t|
      t.string   "name"
      t.integer  "metric_type"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "importance_metric_points", :force => true do |t|
      t.string   "key"
      t.integer  "value"
      t.integer  "importance_metric_id"
      t.integer  "article_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "users", :force => true do |t|
      t.string   "screen_name"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    create_table "settings", :force => true do |t|
      t.string   "key"
      t.string   "setting_type"
      t.string   "value"
    end
  end
end
