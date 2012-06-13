class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.integer :productID
      t.integer :orderID
      t.integer :customerID
      t.date :pickupDate
      t.date :deliveryDate
      t.string :title
      t.timestamps
    end
  end
end
