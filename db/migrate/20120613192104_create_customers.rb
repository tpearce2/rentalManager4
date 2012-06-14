class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.integer :customerID
      t.text :note
      t.boolean :status, :default => 1
      t.timestamps
    end
  end
end
