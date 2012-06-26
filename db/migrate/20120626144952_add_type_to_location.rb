class AddTypeToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :location_type, "ENUM('single', 'recurring')", :default => 'single' 
  end
end
