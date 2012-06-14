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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120614160639) do

  create_table "customers", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "customerID"
    t.text     "note"
    t.boolean  "status",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "locations", :force => true do |t|
    t.integer  "customer_id"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "country"
    t.string   "first_name"
    t.string   "last_name"
    t.decimal  "latitude",      :precision => 10, :scale => 6
    t.decimal  "longitude",     :precision => 10, :scale => 6
    t.string   "phone"
    t.string   "province"
    t.string   "zip"
    t.string   "name"
    t.string   "country_code"
    t.string   "province_code"
    t.boolean  "status",                                       :default => true
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  create_table "products", :force => true do |t|
    t.integer  "productID"
    t.string   "handle"
    t.string   "title"
    t.text     "body_html"
    t.string   "tags"
    t.decimal  "productPrice", :precision => 10, :scale => 0
    t.string   "productSku"
    t.integer  "quantity"
    t.string   "productImage"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "rentals", :force => true do |t|
    t.integer  "product_id"
    t.integer  "location_id"
    t.integer  "customer_id"
    t.integer  "orderID"
    t.date     "pickupDate"
    t.date     "deliveryDate"
    t.integer  "chargifyID"
    t.string   "type",         :limit => 0, :default => "single"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "webhook_events", :force => true do |t|
    t.string   "event_type"
    t.text     "description"
    t.integer  "product_id"
    t.integer  "customer_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
