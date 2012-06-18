class AddStatusToProduct < ActiveRecord::Migration
  def change
    add_column :products, :status, :boolean, :default => 1
  end
end
