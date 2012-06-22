class CreateUnavailables < ActiveRecord::Migration
  def change
    create_table :unavailables do |t|
      t.string :title
      t.date :awayDate
      t.timestamps
    end
  end
end
