class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :cart_token
      t.integer :cartID
      t.string :name
      t.text :note
      t.timestamps
    end
  end
end
