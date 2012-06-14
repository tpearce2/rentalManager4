class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.integer :product_id
      t.integer :location_id
      t.integer :customer_id
      t.integer :orderID
      t.date :pickupDate
      t.date :deliveryDate
      t.integer :chargifyID
      t.column :type, "ENUM('single', 'recurring')", :default => 'single'
      t.timestamps
    end
  end
end
