class CreateCore < ActiveRecord::Migration
  def change
    create_table "articles", :force => true do |t|
      t.string   "title"
      t.string   "url"
      t.text     "abstract"
      t.integer  "source_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "articles", ["url"], :name => "unique_article", :unique => true

    create_table "importance_metric_points", :force => true do |t|
      t.string   "key"
      t.integer  "value"
      t.integer  "importance_metric_id"
      t.integer  "article_id"
      t.datetime "created_at",           :null => false
      t.datetime "updated_at",           :null => false
    end

    add_index "importance_metric_points", ["importance_metric_id", "article_id", "key", "value"], :name => "unique_importance_metric_point", :unique => true

    create_table "importance_metrics", :force => true do |t|
      t.string   "name"
      t.integer  "metric_type"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    create_table "position_metric_points", :force => true do |t|
      t.string   "key"
      t.integer  "value"
      t.integer  "position_metric_id"
      t.integer  "article_id"
      t.datetime "created_at",         :null => false
      t.datetime "updated_at",         :null => false
    end

    add_index "position_metric_points", ["position_metric_id", "article_id", "key", "value"], :name => "unique_position_metric_point", :unique => true

    create_table "position_metrics", :force => true do |t|
      t.string   "name"
      t.integer  "metric_type"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    create_table "settings", :force => true do |t|
      t.string "key"
      t.string "setting_type"
      t.string "value"
    end

    create_table "sources", :force => true do |t|
      t.string   "title"
      t.string   "location"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "user_position_metric_points", :force => true do |t|
      t.string   "key"
      t.string   "value"
      t.integer  "user_position_metric_id"
      t.integer  "user_id"
      t.datetime "created_at",              :null => false
      t.datetime "updated_at",              :null => false
    end

    add_index "position_metric_points", ["user_position_metric_id", "user_id", "key", "value"], :name => "unique_upmp", :unique => true

    create_table "user_position_metrics", :force => true do |t|
      t.string   "name"
      t.string   "metric_type"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end


    create_table "users", :force => true do |t|
      t.string   "screen_name",               :limit => 40
      t.string   "reset_code",                :limit => 50
      t.string   "role",                      :limit => 50, :default => "Admin"
      t.datetime "join_date",                               :default => '2012-02-24 15:24:14'
      t.text     "info"
      t.text     "website_url"
      t.string   "location",                  :limit => 50, :default => "The Internet"
      t.string   "salt",                      :limit => 50
      t.string   "remember_token",            :limit => 50
      t.datetime "remember_token_expires_at"
      t.string   "crypted_password",          :limit => 50
      t.string   "name"
      t.string   "oauth_token"
      t.string   "oauth_token_secret"
      t.string   "uid"
      t.string   "provider"
    end

  end
end
