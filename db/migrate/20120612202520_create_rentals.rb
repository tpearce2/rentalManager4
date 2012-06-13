class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.integer :product_id
      t.integer :order_id
      t.integer :customer_id
      t.date :pickupDate
      t.date :deliveryDate
      t.column :type, "ENUM('single', 'recurring')"
      t.timestamps
    end
  end
end
