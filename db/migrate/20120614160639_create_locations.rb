class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :customer_id
      t.string :address1
      t.string :address2
      t.string :city
      t.string :country
      t.string :first_name
      t.string :last_name
      t.decimal :latitude, :precision => 10, :scale => 6
      t.decimal :longitude, :precision => 10, :scale => 6
      t.string :phone
      t.string :province
      t.string :zip
      t.string :name
      t.string :country_code
      t.string :province_code
      t.boolean :status, :default => 1
      t.timestamps
    end
  end
end
