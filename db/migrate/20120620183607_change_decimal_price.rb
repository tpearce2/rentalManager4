class ChangeDecimalPrice < ActiveRecord::Migration
  def change
    change_column :products, :productPrice, :decimal, :precision => 10, :scale => 6
  end
end
