class AddOrderNoteToRental < ActiveRecord::Migration
  def change
    add_column :rentals, :order_note, :text
  end
end