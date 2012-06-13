class CreateWebhookEvents < ActiveRecord::Migration
  def change
    create_table :webhook_events do |t|
      t.string :event_type
      t.text :description
      t.integer :product_id
      t.integer :customer_id

      t.timestamps
    end
  end
end
