class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :productID
      t.string :handle
      t.string :title
      t.text :body_html
      t.string :tags
      t.decimal :productPrice
      t.string :productSku
      t.integer :quantity
      t.string :productImage

      t.timestamps
    end
  end
end
