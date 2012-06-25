class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :location_id
      t.integer :customer_id
      t.integer :subscriptionID
      t.date :recurringDate
      t.timestamps
    end
  end
end


