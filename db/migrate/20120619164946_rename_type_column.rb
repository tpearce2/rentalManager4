class RenameTypeColumn < ActiveRecord::Migration
  def change
    rename_column :rentals, :type, :rental_type
  end
end
