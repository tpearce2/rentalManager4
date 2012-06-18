class AddCompanyToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :company, :string
  end
end
