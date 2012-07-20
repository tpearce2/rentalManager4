class AddAgeInfo < ActiveRecord::Migration
 def change
    add_column :subscriptions, :ageInfo, :text
  end
end
